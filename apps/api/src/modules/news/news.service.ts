import { Injectable, NotFoundException } from "@nestjs/common";
import { news } from "@repo/db";
import { eq, desc } from "drizzle-orm";

import { DrizzleService } from "../../database/drizzle.service";
import { slugify } from "../../utils/slugify";
import { CreateNewsDto, UpdateNewsDto } from "./dto/news.dto";

/** News is public: expose only the author's public profile, never account fields like email. */
const PUBLIC_AUTHOR = {
  columns: { id: true },
  with: { profile: { columns: { id: true, name: true, title: true, avatarUrl: true } } },
} as const;

@Injectable()
export class NewsService {
  constructor(private readonly drizzle: DrizzleService) {}

  async findAll(isAdmin = false) {
    return await this.drizzle.db.query.news.findMany({
      where: (news, { eq }) => (isAdmin ? undefined : eq(news.isPublished, true)),
      with: {
        author: PUBLIC_AUTHOR,
      },
      orderBy: [desc(news.publishedAt), desc(news.createdAt)],
    });
  }

  async findOne(idOrSlug: string, isAdmin = false) {
    const result = await this.drizzle.db.query.news.findFirst({
      where: (news, { eq, or, and }) => {
        const baseFilter = or(eq(news.id, idOrSlug), eq(news.slug, idOrSlug));
        return isAdmin ? baseFilter : and(baseFilter, eq(news.isPublished, true));
      },
      with: {
        author: PUBLIC_AUTHOR,
      },
    });

    if (!result) throw new NotFoundException("Haber bulunamadı.");
    return result;
  }

  async create(authorId: string, dto: CreateNewsDto) {
    const slug = slugify(dto.title);

    // Check if slug exists, add random suffix if needed
    let finalSlug = slug;
    let counter = 1;
    while (await this.slugExists(finalSlug)) {
      finalSlug = `${slug}-${counter}`;
      counter++;
    }

    const result = await this.drizzle.db
      .insert(news)
      .values({
        title: dto.title,
        slug: finalSlug,
        content: dto.content,
        keywords: dto.keywords,
        authorId,
        isPublished: dto.isPublished ?? false,
        publishedAt: dto.isPublished ? new Date() : null,
      })
      .returning();

    return result[0];
  }

  async update(id: string, dto: UpdateNewsDto) {
    const existing = await this.findOne(id, true);

    const updateData: Partial<typeof news.$inferInsert> = {
      ...dto,
      updatedAt: new Date(),
    };

    if (dto.title && dto.title !== existing.title) {
      let slug = slugify(dto.title);
      let finalSlug = slug;
      let counter = 1;
      while (await this.slugExists(finalSlug, id)) {
        finalSlug = `${slug}-${counter}`;
        counter++;
      }
      updateData.slug = finalSlug;
    }

    if (dto.isPublished === true && !existing.isPublished) {
      updateData.publishedAt = new Date();
    }

    const result = await this.drizzle.db
      .update(news)
      .set(updateData)
      .where(eq(news.id, id))
      .returning();

    return result[0];
  }

  async remove(id: string) {
    const result = await this.drizzle.db.delete(news).where(eq(news.id, id)).returning();
    return result[0];
  }

  private async slugExists(slug: string, excludeId?: string) {
    const result = await this.drizzle.db.query.news.findFirst({
      where: (news, { eq, and, ne }) => {
        const cond = [eq(news.slug, slug)];
        if (excludeId) cond.push(ne(news.id, excludeId));
        return and(...cond);
      },
    });
    return !!result;
  }
}
