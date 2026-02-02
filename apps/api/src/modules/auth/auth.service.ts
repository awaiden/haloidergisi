import { BadRequestException, Injectable, Logger } from "@nestjs/common";
import { EventEmitter2 } from "@nestjs/event-emitter";
import { JwtService } from "@nestjs/jwt";
import argon2 from "argon2";

import { EMAIL_EVENTS } from "@/constants";
import { PrismaService } from "@/database";
import { ResetPasswordEmailDto } from "@/services/mail.service";

import { TokensService } from "../tokens/tokens.service";
import { UsersService } from "../users/users.service";
import { LoginDto, RegisterDto, ResetPasswordDto } from "./auth.dto";

@Injectable()
export class AuthService {
  private logger = new Logger(AuthService.name);

  constructor(
    private readonly prismaService: PrismaService,
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

    const user = await this.prismaService.user.findUnique({
      where: { email },
    });

    if (!user) {
      throw new BadRequestException("Invalid credentials");
    }

    if (!user.password) {
      // First login
      user.password = await argon2.hash(password);

      await this.prismaService.user.update({
        where: { id: user.id },
        data: { password: user.password },
      });
    } else {
      const isPasswordValid = await argon2.verify(user.password, password);
      if (!isPasswordValid) {
        throw new BadRequestException("Invalid credentials");
      }
    }

    const { token } = await this.tokensService.generateToken(user.id);

    return { token };
  }

  async logout(token: string) {
    return this.tokensService.remove(token);
  }

  async initiatePasswordReset(email: string) {
    const user = await this.prismaService.user.findUnique({
      where: { email },
      include: { profile: true },
    });

    if (!user) {
      throw new BadRequestException("User not found");
    }

    const token = this.jwtService.sign(
      { sub: user.id, type: "reset_password" },
      { expiresIn: "15m" },
    );

    // In a real application, you would send this token via email
    this.logger.log(`Password reset token for ${email}: ${token}`);
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

    try {
      const payload = this.jwtService.verify(token);

      if (payload.type !== "reset_password") {
        throw new BadRequestException("Geçersiz token tipi");
      }

      const userId = payload.sub;

      await this.usersService.update(userId, { password: newPassword });

      return { success: true };
    } catch {
      throw new BadRequestException("Geçersiz veya süresi dolmuş token");
    }
  }
}
