import { Controller, Get, INestApplication } from "@nestjs/common";
import { APP_GUARD } from "@nestjs/core";
import { Test } from "@nestjs/testing";
import { Throttle, ThrottlerModule } from "@nestjs/throttler";
import request from "supertest";

import { AUTH_THROTTLE, ClientIpThrottlerGuard } from "./throttler.guard";

@Controller()
class TestController {
  @Get("open")
  open() {
    return "ok";
  }

  @Get("strict")
  @Throttle(AUTH_THROTTLE)
  strict() {
    return "ok";
  }
}

describe("ClientIpThrottlerGuard", () => {
  let app: INestApplication;

  beforeEach(async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [ThrottlerModule.forRoot([{ name: "default", ttl: 60_000, limit: 600 }])],
      controllers: [TestController],
      providers: [{ provide: APP_GUARD, useClass: ClientIpThrottlerGuard }],
    }).compile();
    app = moduleRef.createNestApplication();
    await app.init();
  });

  afterEach(() => app.close());

  it("limits strict routes per client IP", async () => {
    const server = app.getHttpServer();
    for (let i = 0; i < AUTH_THROTTLE.default.limit; i++) {
      await request(server).get("/strict").set("cf-connecting-ip", "1.1.1.1").expect(200);
    }
    await request(server).get("/strict").set("cf-connecting-ip", "1.1.1.1").expect(429);
    // A different client is tracked separately, and other routes keep the global limit.
    await request(server).get("/strict").set("cf-connecting-ip", "2.2.2.2").expect(200);
    await request(server).get("/open").set("cf-connecting-ip", "1.1.1.1").expect(200);
  });
});
