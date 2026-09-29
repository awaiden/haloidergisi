import { MailerModule } from "@nestjs-modules/mailer";
import { MiddlewareConsumer, NestModule } from "@nestjs/common";
import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { APP_GUARD, APP_INTERCEPTOR } from "@nestjs/core";
import { EventEmitterModule } from "@nestjs/event-emitter";
import { JwtModule } from "@nestjs/jwt";
import { ScheduleModule } from "@nestjs/schedule";
import { ThrottlerModule } from "@nestjs/throttler";

import { DrizzleModule } from "@/database";
import { AuthGuard } from "@/guards/auth.guard";
import { ClientIpThrottlerGuard } from "@/guards/throttler.guard";
import { StripSensitiveFieldsInterceptor } from "@/interceptors";
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
    // Generous global limit per client IP; auth endpoints use AUTH_THROTTLE.
    ThrottlerModule.forRoot([{ name: "default", ttl: 60_000, limit: 600 }]),
    DrizzleModule,
    ...modules,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    MailService,
    // Throttling runs first so unauthenticated floods are limited too.
    {
      provide: APP_GUARD,
      useClass: ClientIpThrottlerGuard,
    },
    {
      provide: APP_GUARD,
      useClass: AuthGuard,
    },
    {
      provide: APP_INTERCEPTOR,
      useClass: StripSensitiveFieldsInterceptor,
    },
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(LoggerMiddleware).forRoutes("*");
  }
}
