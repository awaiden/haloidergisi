import "dotenv/config";
import type { NestExpressApplication } from "@nestjs/platform-express";

import { NestFactory } from "@nestjs/core";

import { AppModule } from "./app/app.module";
import { configureApp } from "./app/configure-app";

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  configureApp(app);

  await app.listen(process.env.PORT ?? 3000);
}

bootstrap().catch((err) => {
  console.error("Error during app bootstrap:", err);
  process.exit(1);
});
