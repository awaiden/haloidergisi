import { BadRequestException, Injectable } from "@nestjs/common";
import { EventEmitter2 } from "@nestjs/event-emitter";
import { JwtService } from "@nestjs/jwt";
import argon from "argon2";

import { EMAIL_EVENTS } from "@/constants";
import { PrismaService } from "@/database";
import { VerifyEmailDto } from "@/services/mail.service";

import { UsersService } from "../users/users.service";
import { ChangePasswordDto, UpdateAccountDto, UpdateNotificationsDto } from "./account.dto";
@Injectable()
export class AccountService {
  private readonly emailVerifications = new Map<string, string>();
  constructor(
    private readonly prisma: PrismaService,
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  findOne(userId: string) {
    return this.usersService.findOne(userId);
  }

  async getNotifications(userId: string) {
    const settings = await this.prisma.notificationSettings.findUnique({
      where: { userId },
    });

    return settings;
  }

  async updateNotifications(userId: string, data: UpdateNotificationsDto) {
    const settings = await this.prisma.notificationSettings.upsert({
      where: { userId },
      update: { ...data },
      create: { userId, ...data },
    });

    return settings;
  }

  async getProviders(userId: string) {
    const providers = await this.prisma.provider.findMany({
      where: { userId },
    });

    return providers;
  }

  update(userId: string, data: UpdateAccountDto) {
    return this.usersService.update(userId, data);
  }

  remove(userId: string) {
    return this.usersService.remove(userId);
  }

  async changePassword(userId: string, data: ChangePasswordDto) {
    const user = await this.usersService.findOne(userId);

    const isCurrentPasswordValid = await argon.verify(user.password!, data.currentPassword);

    if (!isCurrentPasswordValid) {
      throw new BadRequestException("Current password is incorrect");
    }

    await this.usersService.update(userId, {
      password: data.newPassword, // will be hashed in UsersService
    });

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
    const provider = await this.prisma.provider.findFirst({
      where: { id: providerId, userId },
    });

    if (!provider) {
      throw new BadRequestException("No linked provider found.");
    }

    await this.prisma.provider.delete({
      where: { id: provider.id },
    });

    return { success: true };
  }
}
