import { BadRequestException } from "@nestjs/common";
import { posts } from "@repo/db";
import { SQL } from "drizzle-orm";
import { PgDialect } from "drizzle-orm/pg-core";

import { applyQuery } from "./drizzle";

const dialect = new PgDialect();
const render = (sql: SQL | undefined) => (sql ? dialect.sqlToQuery(sql) : undefined);

describe("applyQuery", () => {
  it("builds equality and operator filters on real columns", () => {
    const { where } = applyQuery(posts, {
      where: { status: "PUBLISHED", title: { contains: "Dal" }, createdAt: { gte: "2026-01-01" } },
    });
    const query = render(where);
    expect(query?.sql).toBe(
      '("Post"."status" = $1 and "Post"."title" ilike $2 and "Post"."createdAt" >= $3)',
    );
    // JSON dates arrive as strings; timestamp columns get a real Date.
    expect(query?.params).toEqual(["PUBLISHED", "%Dal%", "2026-01-01T00:00:00.000Z"]);
  });

  it("rejects dates that don't parse", () => {
    expect(() => applyQuery(posts, { where: { createdAt: { gte: "yesterday-ish" } } })).toThrow(
      BadRequestException,
    );
  });

  it("supports OR groups, AND lists and in / notIn", () => {
    const { where } = applyQuery(posts, {
      where: {
        OR: [{ title: { contains: "a" } }, { slug: "b" }],
        AND: [{ id: { in: ["1", "2"] } }, { id: { notIn: ["3"] } }],
      },
    });
    const query = render(where);
    expect(query?.sql).toBe(
      '(("Post"."title" ilike $1 or "Post"."slug" = $2) and "Post"."id" in ($3, $4) and "Post"."id" not in ($5))',
    );
  });

  it("filters through a mapped relation with a subquery", () => {
    const { where } = applyQuery(posts, { where: { category: { name: { contains: "Şiir" } } } });
    const query = render(where);
    expect(query?.sql).toContain('"Post"."categoryId" in (select "id" from "Category"');
    expect(query?.params).toEqual(["%Şiir%"]);
  });

  it("ignores unknown keys, including non-column table properties", () => {
    const { where, orderBy } = applyQuery(posts, {
      where: { nope: 1, _: 1, constructor: 1 },
      orderBy: { nope: "asc", toString: "desc" } as Record<string, "asc" | "desc">,
    });
    expect(where).toBeUndefined();
    expect(orderBy).toBeUndefined();
  });

  it("passes ordering and pagination through", () => {
    const result = applyQuery(posts, {
      orderBy: { createdAt: "desc" },
      take: 10,
      skip: 20,
      include: { category: true },
    });
    expect(result.orderBy?.map((o) => render(o)?.sql)).toEqual(['"Post"."createdAt" desc']);
    expect(result).toMatchObject({ limit: 10, offset: 20, with: { category: true } });
  });
});
