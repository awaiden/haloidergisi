import { MailerModule } from "@nestjs-modules/mailer";
import { MiddlewareConsumer, NestModule } from "@nestjs/common";
import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { EventEmitterModule } from "@nestjs/event-emitter";
import { JwtModule } from "@nestjs/jwt";
import { ScheduleModule } from "@nestjs/schedule";

import { PrismaModule } from "@/database";
import { LoggerMiddleware } from "@/middlewares/logger.middleware";
import modules from "@/modules";
import { MailService } from "@/services/mail.service";

import { AppController } from "./app.controller";
import { AppService } from "./app.service";

@Module({
  imports: [
    EventEmitterModule.forRoot(),
    JwtModule.register({
      secret: process.env.JWT_SECRET,
      global: true,
    }),
    MailerModule.forRoot({
      transport: {
        host: process.env.SMTP_HOST,
        port: 587,
        secure: false,
        auth: {
          user: process.env.SMTP_USER,
          pass: process.env.SMTP_PASS,
        },
      },
      defaults: {
        from: `"HALO Dergisi" <${process.env.SMTP_USER}>`,
      },
    }),
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    ScheduleModule.forRoot(),
    PrismaModule,
    ...modules,
  ],
  controllers: [AppController],
  providers: [AppService, MailService],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(LoggerMiddleware).forRoutes("*");
  }
}
