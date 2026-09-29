import { BadRequestException, Injectable } from "@nestjs/common";
import { EventEmitter2 } from "@nestjs/event-emitter";
import { JwtService } from "@nestjs/jwt";
import { notificationSettings, providers } from "@repo/db";
import argon from "argon2";
import { eq, and } from "drizzle-orm";

import { EMAIL_EVENTS } from "@/constants";
import { DrizzleService } from "@/database";
import { VerifyEmailDto } from "@/services/mail.service";

import { TokensService } from "../tokens/tokens.service";
import { UsersService } from "../users/users.service";
import { ChangePasswordDto, UpdateAccountDto, UpdateNotificationsDto } from "./account.dto";
@Injectable()
export class AccountService {
  private readonly emailVerifications = new Map<string, string>();
  constructor(
    private readonly drizzle: DrizzleService,
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
    private readonly eventEmitter: EventEmitter2,
    private readonly tokensService: TokensService,
  ) {}

  findOne(userId: string) {
    return this.usersService.findOne(userId);
  }

  async getNotifications(userId: string) {
    const settings = await this.drizzle.db.query.notificationSettings.findFirst({
      where: eq(notificationSettings.userId, userId),
    });

    return settings;
  }

  async updateNotifications(userId: string, data: UpdateNotificationsDto) {
    const settings = await this.drizzle.db
      .insert(notificationSettings)
      .values({ userId, ...data })
      .onConflictDoUpdate({
        target: notificationSettings.userId,
        set: { ...data, updatedAt: new Date() },
      })
      .returning();

    return settings[0];
  }

  async getProviders(userId: string) {
    const results = await this.drizzle.db.query.providers.findMany({
      where: eq(providers.userId, userId),
    });

    return results;
  }

  update(userId: string, data: UpdateAccountDto) {
    return this.usersService.update(userId, data);
  }

  remove(userId: string) {
    return this.usersService.remove(userId);
  }

  async changePassword(userId: string, data: ChangePasswordDto, currentToken?: string) {
    const user = await this.usersService.findOne(userId);

    const isCurrentPasswordValid =
      !!user.password && (await argon.verify(user.password, data.currentPassword));

    if (!isCurrentPasswordValid) {
      throw new BadRequestException("Current password is incorrect");
    }

    await this.usersService.update(userId, {
      password: data.newPassword, // will be hashed in UsersService
    });

    // Sign out every other device; the session that made the change stays valid.
    await this.tokensService.removeAllForUser(userId, currentToken);

    return { success: true };
  }

  async requestEmailVerification(userId: string) {
    const user = await this.usersService.findOne(userId);

    if (user.emailVerifiedAt) {
      throw new BadRequestException("Email zaten doğrulanmış.");
    }

    const token = this.jwtService.sign(
      { sub: user.id, email: user.email, type: "email_verification" },
      { expiresIn: "1h" },
    );

    this.eventEmitter.emit(
      EMAIL_EVENTS.VERIFY_EMAIL,
      new VerifyEmailDto({
        to: user.email,
        name: user.profile?.name || "Kullanıcı",
        token,
      }),
    );

    return { success: true };
  }

  async verifyEmail(userId: string, token: string) {
    try {
      // Token'ı doğrula
      const payload = this.jwtService.verify(token);

      // Güvenlik kontrolleri
      if (payload.type !== "email_verification") {
        throw new BadRequestException("Geçersiz işlem tipi.");
      }

      if (payload.sub !== userId) {
        throw new BadRequestException("Bu token başka bir kullanıcıya ait.");
      }

      // Kullanıcının mevcut e-postası, token oluşturulduğundaki ile aynı mı?
      const user = await this.usersService.findOne(userId);
      if (user.email !== payload.email) {
        throw new BadRequestException("E-posta adresi değişmiş, yeni bir doğrulama isteyin.");
      }

      await this.usersService.update(userId, { emailVerifiedAt: new Date() });

      return { success: true };
    } catch {
      throw new BadRequestException("Geçersiz veya süresi dolmuş doğrulama linki.");
    }
  }

  async removeProvider(userId: string, providerId: string) {
    const provider = await this.drizzle.db.query.providers.findFirst({
      where: and(eq(providers.id, providerId), eq(providers.userId, userId)),
    });

    if (!provider) {
      throw new BadRequestException("No linked provider found.");
    }

    await this.drizzle.db.delete(providers).where(eq(providers.id, provider.id));

    return { success: true };
  }
}
