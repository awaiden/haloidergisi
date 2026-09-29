import "dotenv/config";
import type { NestExpressApplication } from "@nestjs/platform-express";

import { ValidationPipe } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import helmet from "helmet";

import { buildCorsOptions } from "@/utils/cors";

import { AppModule } from "./app/app.module";

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    cors: buildCorsOptions(),
  });

  // Number of reverse proxies in front of the API, so `req.ip` is the client.
  app.set("trust proxy", Number(process.env.TRUST_PROXY ?? 1));
  // JSON API: default headers, but let other origins embed its responses.
  app.use(helmet({ crossOriginResourcePolicy: { policy: "cross-origin" } }));

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
    }),
  );

  await app.listen(process.env.PORT ?? 3000);
}

bootstrap().catch((err) => {
  console.error("Error during app bootstrap:", err);
  process.exit(1);
});
