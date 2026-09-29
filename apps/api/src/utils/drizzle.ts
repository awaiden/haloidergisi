import { BadRequestException } from "@nestjs/common";
import { categories, crews, db, profiles, users } from "@repo/db";
import {
  and,
  is,
  SQL,
  asc,
  desc,
  eq,
  gt,
  gte,
  ilike,
  inArray,
  lt,
  lte,
  ne,
  notInArray,
  or,
} from "drizzle-orm";
import { PgColumn, type PgTable } from "drizzle-orm/pg-core";

import type { DrizzleQueryParams } from "@/decorators/drizzle-query.decorator";

// Maps a relation key (as used in dotted `searchableFields`, e.g. "category.name")
// to the foreign table and the columns that join it to the table being queried.
const RELATION_MAP: Record<string, { table: PgTable; localKey: string; foreignKey: string }> = {
  category: { table: categories, localKey: "categoryId", foreignKey: "id" },
  profile: { table: profiles, localKey: "id", foreignKey: "userId" },
  crew: { table: crews, localKey: "crewId", foreignKey: "id" },
  user: { table: users, localKey: "userId", foreignKey: "id" },
};

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

/**
 * The column called `key`, or undefined. Keys come from the request, so only
 * own properties that really are columns count (not `constructor`, `_`, …).
 */
function columnOf(table: PgTable, key: string): PgColumn | undefined {
  if (!Object.hasOwn(table, key)) return undefined;
  const value = (table as unknown as Record<string, unknown>)[key];
  return is(value, PgColumn) ? value : undefined;
}

/** Filters arrive as JSON, so dates are strings; timestamp columns need Dates. */
function toDriverValue(column: PgColumn, value: unknown): unknown {
  if (column.dataType === "date" && (typeof value === "string" || typeof value === "number")) {
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) {
      throw new BadRequestException(`Invalid date for '${column.name}'.`);
    }
    return date;
  }
  return value;
}

function buildRelationCondition(table: PgTable, key: string, val: Record<string, unknown>) {
  const relation = RELATION_MAP[key];
  const localColumn = columnOf(table, relation.localKey);
  const foreignKey = columnOf(relation.table, relation.foreignKey);
  const [relationField] = Object.keys(val);
  const relationColumn = relationField ? columnOf(relation.table, relationField) : undefined;
  if (!localColumn || !foreignKey || !relationColumn) return undefined;

  const relationVal = val[relationField];
  const subquery = db
    .select({ id: foreignKey })
    .from(relation.table)
    .where(
      isRecord(relationVal) && "contains" in relationVal
        ? ilike(relationColumn, `%${String(relationVal.contains)}%`)
        : eq(relationColumn, toDriverValue(relationColumn, relationVal)),
    );

  return inArray(localColumn, subquery);
}

function buildCondition(table: PgTable, key: string, val: unknown): SQL | undefined {
  if (
    Object.hasOwn(RELATION_MAP, key) &&
    isRecord(val) &&
    !("contains" in val) &&
    !("not" in val)
  ) {
    return buildRelationCondition(table, key, val);
  }

  const column = columnOf(table, key);
  if (!column) return undefined;
  const value = (operand: unknown) => toDriverValue(column, operand);

  if (isRecord(val)) {
    if ("not" in val) return ne(column, value(val.not));
    if ("contains" in val) return ilike(column, `%${String(val.contains)}%`);
    if ("gt" in val) return gt(column, value(val.gt));
    if ("gte" in val) return gte(column, value(val.gte));
    if ("lt" in val) return lt(column, value(val.lt));
    if ("lte" in val) return lte(column, value(val.lte));
    if ("in" in val && Array.isArray(val.in)) return inArray(column, val.in.map(value));
    if ("notIn" in val && Array.isArray(val.notIn)) {
      return notInArray(column, val.notIn.map(value));
    }
    return eq(column, val);
  }

  return eq(column, value(val));
}

function buildOrGroup(table: PgTable, entries: unknown[]): SQL | undefined {
  const orFilters: SQL[] = [];
  for (const entry of entries) {
    if (!isRecord(entry)) continue;
    const [key] = Object.keys(entry);
    if (key === undefined) continue;
    const condition = buildCondition(table, key, entry[key]);
    if (condition) orFilters.push(condition);
  }
  return orFilters.length > 0 ? or(...orFilters) : undefined;
}

export function applyQuery(table: PgTable, query: DrizzleQueryParams) {
  const filters: SQL[] = [];

  for (const [key, value] of Object.entries(query.where ?? {})) {
    if (key === "OR" && Array.isArray(value)) {
      const orCondition = buildOrGroup(table, value);
      if (orCondition) filters.push(orCondition);
    } else if (key === "AND" && Array.isArray(value)) {
      for (const entry of value) {
        if (!isRecord(entry)) continue;
        for (const [entryKey, entryValue] of Object.entries(entry)) {
          const condition =
            entryKey === "OR" && Array.isArray(entryValue)
              ? buildOrGroup(table, entryValue)
              : buildCondition(table, entryKey, entryValue);
          if (condition) filters.push(condition);
        }
      }
    } else {
      const condition = buildCondition(table, key, value);
      if (condition) filters.push(condition);
    }
  }

  const orderBy: SQL[] = [];
  for (const [key, direction] of Object.entries(query.orderBy ?? {})) {
    const column = columnOf(table, key);
    if (column) orderBy.push(direction === "asc" ? asc(column) : desc(column));
  }

  return {
    filters,
    where: filters.length > 0 ? and(...filters) : undefined,
    orderBy: orderBy.length > 0 ? orderBy : undefined,
    limit: query.take,
    offset: query.skip,
    with: query.include,
  };
}
