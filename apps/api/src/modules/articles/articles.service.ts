import { BadRequestException, Injectable, NotFoundException } from "@nestjs/common";
import { EventEmitter2 } from "@nestjs/event-emitter";
import { articles } from "@repo/db";
import { eq, sql } from "drizzle-orm";

import { EMAIL_EVENTS } from "@/constants";
import { DrizzleService } from "@/database/drizzle.service";
import { DrizzleQueryParams } from "@/decorators";
import {
  ArticleStatusUpdatedEmailDto,
  ArticleSubmittedAdminEmailDto,
  ArticleSubmittedAuthorEmailDto,
} from "@/services/mail.service";
import { applyQuery } from "@/utils";

import { CreateArticleDto, UpdateArticleDto, UpdateArticleStatusDto } from "./dto/article.dto";

const STATUS_TEXT_MAP: Record<string, string> = {
  PENDING: "Beklemede",
  REVIEWING: "İnceleniyor",
  APPROVED: "Onaylandı",
  REJECTED: "Reddedildi",
  REVISION_REQ: "Revize Gerekli",
};

@Injectable()
export class ArticlesService {
  constructor(
    private readonly drizzle: DrizzleService,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async findAll(query: DrizzleQueryParams) {
    const { where, orderBy, limit, offset } = applyQuery(articles, query);

    const items = await this.drizzle.db.query.articles.findMany({
      where,
      orderBy,
      limit,
      offset,
      with: {
        author: {
          with: {
            profile: true,
          },
        },
        call: true,
      },
    });

    const [{ total }] = await this.drizzle.db
      .select({ total: sql<number>`count(*)` })
      .from(articles)
      .where(where);

    return { items, meta: { total: Number(total), take: query.take, skip: query.skip } };
  }

  async findMyArticles(authorId: string) {
    return await this.drizzle.db.query.articles.findMany({
      where: (articles, { eq }) => eq(articles.authorId, authorId),
      with: {
        call: true,
      },
      orderBy: (articles, { desc }) => [desc(articles.createdAt)],
    });
  }

  async findOne(id: string) {
    const article = await this.drizzle.db.query.articles.findFirst({
      where: (articles, { eq }) => eq(articles.id, id),
      with: {
        author: {
          with: {
            profile: true,
          },
        },
        call: true,
      },
    });
    if (!article) throw new NotFoundException("Yazı bulunamadı.");
    return article;
  }

  async create(authorId: string, dto: CreateArticleDto) {
    const now = new Date();

    // Check if the call is active
    const activeCall = await this.drizzle.db.query.submissionCalls.findFirst({
      where: (calls, { and, eq, lte, gte }) =>
        and(
          eq(calls.id, dto.callId),
          eq(calls.isActive, true),
          lte(calls.startDate, now),
          gte(calls.endDate, now),
        ),
    });

    if (!activeCall) {
      throw new BadRequestException("Bu ilan şu anda yazı kabulüne kapalıdır.");
    }

    // Check if the author already submitted to this call
    const existingArticle = await this.drizzle.db.query.articles.findFirst({
      where: (articles, { and, eq }) =>
        and(eq(articles.callId, dto.callId), eq(articles.authorId, authorId)),
    });

    if (existingArticle) {
      throw new BadRequestException(
        "Bu ilana daha önce yazı gönderdiniz. Her ilana yalnızca bir yazı gönderebilirsiniz.",
      );
    }

    const result = await this.drizzle.db
      .insert(articles)
      .values({
        callId: dto.callId,
        authorId,
        title: dto.title,
        content: dto.content || "",
        fileUrl: dto.fileUrl || null,
        status: "PENDING",
      })
      .returning();

    const created = result[0];

    // Fetch author details for email
    const authorUser = await this.drizzle.db.query.users.findFirst({
      where: (users, { eq }) => eq(users.id, authorId),
      with: { profile: true },
    });

    if (authorUser) {
      const authorName = authorUser.profile?.name || authorUser.email;

      // 1. Send confirmation email to author
      this.eventEmitter.emit(
        EMAIL_EVENTS.ARTICLE_SUBMITTED_AUTHOR,
        new ArticleSubmittedAuthorEmailDto({
          to: authorUser.email,
          authorName,
          articleTitle: created.title,
          callTitle: activeCall.title,
        }),
      );

      // 2. Send notification email to admins
      this.eventEmitter.emit(
        EMAIL_EVENTS.ARTICLE_SUBMITTED_ADMIN,
        new ArticleSubmittedAdminEmailDto({
          authorName,
          authorEmail: authorUser.email,
          articleTitle: created.title,
          callTitle: activeCall.title,
          articleId: created.id,
        }),
      );
    }

    return created;
  }

  async update(id: string, dto: UpdateArticleDto) {
    const updatePayload: Record<string, any> = {
      title: dto.title,
      updatedAt: new Date(),
    };
    if (dto.content !== undefined) updatePayload.content = dto.content;
    if (dto.fileUrl !== undefined) updatePayload.fileUrl = dto.fileUrl;

    const result = await this.drizzle.db
      .update(articles)
      .set(updatePayload)
      .where(eq(articles.id, id))
      .returning();
    return result[0];
  }

  async findByCallAndAuthor(callId: string, authorId: string) {
    return await this.drizzle.db.query.articles.findFirst({
      where: (articles, { and, eq }) =>
        and(eq(articles.callId, callId), eq(articles.authorId, authorId)),
    });
  }

  async updateStatus(id: string, dto: UpdateArticleStatusDto) {
    const result = await this.drizzle.db
      .update(articles)
      .set({
        status: dto.status,
        adminNote: dto.adminNote,
        updatedAt: new Date(),
      })
      .where(eq(articles.id, id))
      .returning();

    const updated = result[0];

    // Fetch author info to send status update email
    const articleInfo = await this.drizzle.db.query.articles.findFirst({
      where: (articles, { eq }) => eq(articles.id, id),
      with: {
        author: {
          with: { profile: true },
        },
      },
    });

    if (articleInfo?.author) {
      const authorName = articleInfo.author.profile?.name || articleInfo.author.email;
      const statusText = STATUS_TEXT_MAP[updated.status] || updated.status;

      this.eventEmitter.emit(
        EMAIL_EVENTS.ARTICLE_STATUS_UPDATED,
        new ArticleStatusUpdatedEmailDto({
          to: articleInfo.author.email,
          authorName,
          articleTitle: updated.title,
          status: updated.status,
          statusText,
          adminNote: updated.adminNote || undefined,
        }),
      );
    }

    return updated;
  }

  async remove(id: string) {
    const result = await this.drizzle.db.delete(articles).where(eq(articles.id, id)).returning();
    return result[0];
  }
}
