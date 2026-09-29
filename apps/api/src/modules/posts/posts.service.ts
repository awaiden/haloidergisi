import { BadRequestException, Injectable } from "@nestjs/common";
import { EventEmitter2 } from "@nestjs/event-emitter";
import { PostStatus, posts } from "@repo/db";
import { and, eq, or, sql } from "drizzle-orm";
import slugify from "slugify";

import { EMAIL_EVENTS } from "@/constants";
import { DrizzleService } from "@/database";
import { DrizzleQueryParams } from "@/decorators";
import { NewPostEmailDto } from "@/services/mail.service";
import { applyQuery, pickRelations } from "@/utils";

import { CreatePostDto } from "./dto/create-post.dto";
import { UpdatePostDto } from "./dto/update-post.dto";

@Injectable()
export class PostsService {
  constructor(
    private readonly drizzle: DrizzleService,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  makeSlug(title: string) {
    return slugify(title, { lower: true, strict: true }) + "-" + Date.now();
  }

  async create(createPostDto: CreatePostDto) {
    const generatedSlug = this.makeSlug(createPostDto.title);

    const [post] = await this.drizzle.db
      .insert(posts)
      .values({
        ...createPostDto,
        slug: generatedSlug,
      })
      .returning();

    this.eventEmitter.emit(
      EMAIL_EVENTS.NEW_POST,
      new NewPostEmailDto({
        title: post.title,
        content: post.content ?? "",
        slug: post.slug,
        coverImage: post.coverImage ?? "",
      }),
    );

    return post;
  }

  /** `publishedOnly` hides drafts/archived posts from public (non-admin) callers. */
  async findAll(query: DrizzleQueryParams, publishedOnly = false) {
    const scoped = publishedOnly
      ? { ...query, where: { ...query.where, status: PostStatus.PUBLISHED } }
      : query;
    const { where, orderBy, limit, offset, with: include } = applyQuery(posts, scoped);

    const items = await this.drizzle.db.query.posts.findMany({
      limit,
      offset,
      where,
      orderBy,
      with: {
        // Public endpoint: only relations the clients need can be requested.
        ...pickRelations(include, ["category"]),
        themes: true,
      },
    });

    const [{ total }] = await this.drizzle.db
      .select({ total: sql<number>`count(*)` })
      .from(posts)
      .where(where);

    return { items, meta: { total: Number(total), take: query.take, skip: query.skip } };
  }

  async findOne(id: string, publishedOnly = false) {
    const byIdOrSlug = or(eq(posts.id, id), eq(posts.slug, id));
    const post = await this.drizzle.db.query.posts.findFirst({
      where: publishedOnly ? and(byIdOrSlug, eq(posts.status, PostStatus.PUBLISHED)) : byIdOrSlug,
      with: {
        themes: true,
        category: true,
      },
    });

    if (!post) {
      throw new BadRequestException(`Post with id ${id} not found`);
    }

    return post;
  }

  async update(id: string, updatePostDto: UpdatePostDto) {
    const post = await this.findOne(id);

    const [updatedPost] = await this.drizzle.db
      .update(posts)
      .set(updatePostDto)
      .where(eq(posts.id, post.id))
      .returning();

    return updatedPost;
  }

  async remove(id: string) {
    const post = await this.findOne(id);

    await this.drizzle.db.delete(posts).where(eq(posts.id, post.id));

    return { success: true };
  }
}
