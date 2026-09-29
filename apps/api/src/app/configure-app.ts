import type { NestExpressApplication } from "@nestjs/platform-express";

import { ValidationPipe } from "@nestjs/common";
import helmet from "helmet";

import { buildCorsOptions } from "@/utils/cors";

/** HTTP setup shared by `main.ts` and the e2e tests. */
export function configureApp(app: NestExpressApplication): void {
  app.enableCors(buildCorsOptions());

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
}
