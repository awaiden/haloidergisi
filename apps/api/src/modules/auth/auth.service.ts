import { BadRequestException, Injectable } from "@nestjs/common";
import { EventEmitter2 } from "@nestjs/event-emitter";
import { JwtService } from "@nestjs/jwt";
import { users } from "@repo/db";
import argon2 from "argon2";
import { eq } from "drizzle-orm";

import { EMAIL_EVENTS } from "@/constants";
import { DrizzleService } from "@/database";
import { ResetPasswordEmailDto } from "@/services/mail.service";

import { TokensService } from "../tokens/tokens.service";
import { UsersService } from "../users/users.service";
import { LoginDto, RegisterDto, ResetPasswordDto } from "./auth.dto";

@Injectable()
export class AuthService {
  constructor(
    private readonly drizzle: DrizzleService,
    private readonly tokensService: TokensService,
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async register(registerDto: RegisterDto) {
    return this.usersService.create(registerDto);
  }

  async login(loginDto: LoginDto) {
    const { email, password } = loginDto;

    const user = await this.drizzle.db.query.users.findFirst({
      where: eq(users.email, email),
    });

    // Accounts without a password (e.g. legacy imports) must set one via the
    // forgot-password flow; never accept whatever password is sent first.
    if (!user?.password || !(await argon2.verify(user.password, password))) {
      throw new BadRequestException("Invalid credentials");
    }

    const { token } = await this.tokensService.generateToken(user.id);

    return { token };
  }

  async logout(token: string) {
    return this.tokensService.remove(token);
  }

  async initiatePasswordReset(email: string) {
    const user = await this.drizzle.db.query.users.findFirst({
      where: eq(users.email, email),
      with: { profile: true },
    });

    // Same response whether or not the account exists, so this endpoint
    // can't be used to check which emails are registered.
    if (!user) {
      return { success: true };
    }

    const token = this.jwtService.sign(
      { sub: user.id, type: "reset_password" },
      { expiresIn: "15m" },
    );

    this.eventEmitter.emit(
      EMAIL_EVENTS.RESET_PASSWORD,
      new ResetPasswordEmailDto({
        to: email,
        name: user.profile?.name || "Kullanıcı",
        token,
      }),
    );

    return { success: true };
  }

  async resetPassword(body: ResetPasswordDto) {
    const { token, newPassword } = body;

    let payload: { sub: string; type: string };
    try {
      payload = this.jwtService.verify(token);
    } catch {
      throw new BadRequestException("Geçersiz veya süresi dolmuş token");
    }

    if (payload.type !== "reset_password") {
      throw new BadRequestException("Geçersiz token tipi");
    }

    await this.usersService.update(payload.sub, { password: newPassword });
    // Whoever had the old password may still be signed in somewhere.
    await this.tokensService.removeAllForUser(payload.sub);

    return { success: true };
  }
}
