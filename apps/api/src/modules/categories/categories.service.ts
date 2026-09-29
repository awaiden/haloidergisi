import { Injectable, NotFoundException } from "@nestjs/common";
import { categories, PostStatus, posts } from "@repo/db";
import { and, eq, inArray, sql } from "drizzle-orm";

import { DrizzleService } from "@/database";
import { DrizzleQueryParams } from "@/decorators";
import { applyQuery } from "@/utils";

import { CreateCategoryDto } from "./dto/create-category.dto";
import { UpdateCategoryDto } from "./dto/update-category.dto";

@Injectable()
export class CategoriesService {
  constructor(private drizzle: DrizzleService) {}

  async create(createCategoryDto: CreateCategoryDto) {
    const [category] = await this.drizzle.db
      .insert(categories)
      .values(createCategoryDto)
      .returning();
    return category;
  }

  async findAll(query: DrizzleQueryParams, onlyWithPublishedPosts = false) {
    const applied = applyQuery(categories, query);
    const { orderBy, limit, offset } = applied;
    let where = applied.where;
    if (onlyWithPublishedPosts) {
      const used = await this.drizzle.db
        .selectDistinct({ id: posts.categoryId })
        .from(posts)
        .where(eq(posts.status, PostStatus.PUBLISHED));
      const ids = used.map((row) => row.id).filter((id): id is string => id !== null);
      where = and(where, ids.length ? inArray(categories.id, ids) : sql`false`);
    }

    const items = await this.drizzle.db.query.categories.findMany({
      where,
      orderBy,
      limit,
      offset,
    });

    const [{ total }] = await this.drizzle.db
      .select({ total: sql<number>`count(*)` })
      .from(categories)
      .where(where);

    return { items, meta: { total: Number(total), skip: query.skip, take: query.take } };
  }

  async findOne(id: string) {
    const category = await this.drizzle.db.query.categories.findFirst({
      where: eq(categories.id, id),
    });

    if (!category) {
      throw new NotFoundException(`Category with ID ${id} not found`);
    }

    return category;
  }

  async update(id: string, updateCategoryDto: UpdateCategoryDto) {
    await this.findOne(id);

    const [category] = await this.drizzle.db
      .update(categories)
      .set(updateCategoryDto)
      .where(eq(categories.id, id))
      .returning();

    return category;
  }

  async remove(id: string) {
    await this.findOne(id);

    await this.drizzle.db.delete(categories).where(eq(categories.id, id));

    return { success: true };
  }
}
