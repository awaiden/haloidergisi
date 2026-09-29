import { BadRequestException, createParamDecorator, ExecutionContext } from "@nestjs/common";
import { Request } from "express";

export interface DrizzleQueryParams {
  where?: Record<string, any>;
  skip?: number;
  take?: number;
  orderBy?: Record<string, "asc" | "desc">;
  include?: Record<string, boolean>;
}

const MAX_LIMIT = 1000;

function parseJson(value: string | undefined, paramName: string): Record<string, any> {
  if (!value) return {};
  try {
    return JSON.parse(value);
  } catch {
    throw new BadRequestException(`Invalid '${paramName}' query parameter: must be valid JSON.`);
  }
}

/**
 * `fields` selects relations to join, e.g. `{"category":true}`. Only flat
 * `relation: true` pairs are allowed: nested objects would let a public list
 * endpoint reach through relations into other tables (e.g. users' emails).
 */
export function parseFields(value: string | undefined): Record<string, true> | undefined {
  if (!value) return undefined;
  const parsed = parseJson(value, "fields");
  const invalid = Array.isArray(parsed) || Object.values(parsed).some((v) => v !== true);
  if (invalid) {
    throw new BadRequestException(
      "Invalid 'fields' query parameter: expected an object of relation names set to true.",
    );
  }
  return parsed as Record<string, true>;
}

export const DrizzleQuery = createParamDecorator(
  (searchableFields: string[], ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest() as Request;

    const { page, limit, sort, fields, filter, search, ...rest } = request.query as Record<
      string,
      string
    >;

    let take: number | undefined = 10;
    if (limit !== undefined) {
      const limitNum = parseInt(limit, 10);
      if (limitNum === -1) {
        take = undefined;
      } else {
        if (Number.isNaN(limitNum) || limitNum < 1) {
          throw new BadRequestException("Invalid 'limit' query parameter.");
        }
        take = Math.min(limitNum, MAX_LIMIT);
      }
    }

    let pageNum = 1;
    if (page !== undefined) {
      pageNum = parseInt(page, 10);
      if (Number.isNaN(pageNum) || pageNum < 1) {
        throw new BadRequestException("Invalid 'page' query parameter.");
      }
    }

    const skip = take ? (pageNum - 1) * take : 0;

    // createdAt:desc
    const orderBy = sort ? { [sort.split(":")[0]]: sort.split(":")[1] } : { createdAt: "desc" };

    const include = parseFields(fields);

    const parsedFilter = parseJson(filter, "filter");
    const where: Record<string, any> = { ...parsedFilter, ...rest };

    if (search && searchableFields && searchableFields.length > 0) {
      const searchOr = searchableFields.map((field) => {
        if (field.includes(".")) {
          const [relation, relationField] = field.split(".");
          return {
            [relation]: {
              [relationField]: { contains: search },
            },
          };
        }

        return {
          [field]: { contains: search },
        };
      });

      if (where.OR) {
        // Preserve the caller's own OR clause (from `filter`) instead of clobbering it.
        const existingOr = where.OR;
        delete where.OR;
        where.AND = [{ ...where }, { OR: existingOr }, { OR: searchOr }];
        Object.keys(where).forEach((key) => {
          if (key !== "AND") delete where[key];
        });
      } else {
        where.OR = searchOr;
      }
    }

    return {
      where,
      skip,
      take,
      orderBy,
      include,
    };
  },
);
