import { Injectable } from "@nestjs/common";
import { submissionCalls } from "@repo/db";
import { eq, sql } from "drizzle-orm";

import { DrizzleQueryParams } from "@/decorators";
import { applyQuery } from "@/utils";

import { DrizzleService } from "../../database/drizzle.service";
import { CreateSubmissionCallDto, UpdateSubmissionCallDto } from "./dto/submission-call.dto";

@Injectable()
export class SubmissionCallsService {
  constructor(private readonly drizzle: DrizzleService) {}

  async findAll(query: DrizzleQueryParams) {
    const { where, orderBy, limit, offset } = applyQuery(submissionCalls, query);

    const items = await this.drizzle.db.query.submissionCalls.findMany({
      where,
      orderBy,
      limit,
      offset,
    });

    const [{ total }] = await this.drizzle.db
      .select({ total: sql<number>`count(*)` })
      .from(submissionCalls)
      .where(where);

    return { items, meta: { total: Number(total), take: query.take, skip: query.skip } };
  }

  async findActive() {
    const now = new Date();
    return await this.drizzle.db.query.submissionCalls.findMany({
      where: (calls, { and, eq, lte, gte }) =>
        and(eq(calls.isActive, true), lte(calls.startDate, now), gte(calls.endDate, now)),
      orderBy: (calls, { desc }) => [desc(calls.createdAt)],
    });
  }

  async findOne(id: string) {
    return await this.drizzle.db.query.submissionCalls.findFirst({
      where: (calls, { eq }) => eq(calls.id, id),
    });
  }

  async create(dto: CreateSubmissionCallDto) {
    const result = await this.drizzle.db
      .insert(submissionCalls)
      .values({
        title: dto.title,
        description: dto.description,
        startDate: new Date(dto.startDate),
        endDate: new Date(dto.endDate),
        isActive: dto.isActive ?? true,
      })
      .returning();
    return result[0];
  }

  async update(id: string, dto: UpdateSubmissionCallDto) {
    const { startDate, endDate, ...rest } = dto;
    const values: Partial<typeof submissionCalls.$inferInsert> = {
      ...rest,
      ...(startDate && { startDate: new Date(startDate) }),
      ...(endDate && { endDate: new Date(endDate) }),
    };

    const result = await this.drizzle.db
      .update(submissionCalls)
      .set(values)
      .where(eq(submissionCalls.id, id))
      .returning();
    return result[0];
  }

  async remove(id: string) {
    const result = await this.drizzle.db
      .delete(submissionCalls)
      .where(eq(submissionCalls.id, id))
      .returning();
    return result[0];
  }

  async checkSubmission(callId: string, userId: string) {
    return await this.drizzle.db.query.articles.findFirst({
      where: (articles, { and, eq }) =>
        and(eq(articles.callId, callId), eq(articles.authorId, userId)),
    });
  }
}
