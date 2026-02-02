import { ISendMailOptions, MailerService } from "@nestjs-modules/mailer";
import { Injectable, Logger } from "@nestjs/common";
import { OnEvent } from "@nestjs/event-emitter";
import { render } from "@react-email/render";
import { NewPostEmail, ResetPasswordEmail, VerifyEmail, WelcomeEmail } from "@repo/emails";

import { EMAIL_EVENTS } from "@/constants";
import { PrismaService } from "@/database";
import { sleep } from "@/utils";

export class BaseEmailDto {
  to: string;
  constructor(data: BaseEmailDto) {
    Object.assign(this, data);
  }
}

export class WelcomeEmailDto extends BaseEmailDto {
  name: string;
  constructor(data: WelcomeEmailDto) {
    super(data);
    Object.assign(this, data);
  }
}

export class VerifyEmailDto extends BaseEmailDto {
  name: string;
  token: string;
  constructor(data: VerifyEmailDto) {
    super(data);
    Object.assign(this, data);
  }
}

export class ResetPasswordEmailDto extends BaseEmailDto {
  name: string;
  token: string;
  constructor(data: ResetPasswordEmailDto) {
    super(data);
    Object.assign(this, data);
  }
}

export class NewPostEmailDto {
  title: string;
  content: string;
  slug: string;
  coverImage: string;

  constructor(data: NewPostEmailDto) {
    Object.assign(this, data);
  }
}

@Injectable()
export class MailService {
  private readonly logger = new Logger(MailService.name);
  constructor(
    private readonly mailerService: MailerService,
    private readonly prisma: PrismaService,
  ) {}

  async send(options: ISendMailOptions) {
    try {
      await this.mailerService.sendMail(options);
      this.logger.log(`Mail sent to ${options.to as string} with subject "${options.subject}"`);
    } catch (error) {
      this.logger.error(`Failed to send mail to ${options.to as string}: ${error}`);
    }
  }

  @OnEvent(EMAIL_EVENTS.WELCOME)
  async sendWelcomeEmail({ to, ...rest }: WelcomeEmailDto) {
    await this.send({
      to,
      subject: "HALO Dergisi'ne Hoş Geldiniz!",
      html: await render(
        WelcomeEmail({
          ...rest,
        }),
      ),
    });
  }

  @OnEvent(EMAIL_EVENTS.VERIFY_EMAIL)
  async sendVerifyEmail({ to, ...rest }: VerifyEmailDto) {
    await this.send({
      to,
      subject: "E-posta Adresinizi Doğrulayın",
      html: await render(
        VerifyEmail({
          ...rest,
        }),
      ),
    });
  }

  @OnEvent(EMAIL_EVENTS.RESET_PASSWORD)
  async sendResetPasswordEmail({ to, ...rest }: ResetPasswordEmailDto) {
    await this.send({
      to,
      subject: "Şifre Sıfırlama Talebi",
      html: await render(
        ResetPasswordEmail({
          ...rest,
        }),
      ),
    });
  }

  @OnEvent(EMAIL_EVENTS.NEW_POST)
  async sendNewPostEmail({ ...rest }: NewPostEmailDto) {
    const users = await this.prisma.user.findMany({
      where: { notificationSettings: { newPost: true } },
      include: { profile: true },
    });

    for (const user of users) {
      await this.send({
        subject: "Yeni Bir Gönderi Yayınlandı!",
        html: await render(
          NewPostEmail({
            ...rest,
            name: user.profile?.name || "HALO Okuyucusu",
          }),
        ),
      });

      await sleep(Math.random() * 1000 + 500);
    }
  }
}
