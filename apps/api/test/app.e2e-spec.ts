import type { NestExpressApplication } from "@nestjs/platform-express";

import { Test } from "@nestjs/testing";
import request from "supertest";
import { App } from "supertest/types";

import { AppModule } from "../src/app/app.module";
import { configureApp } from "../src/app/configure-app";

// arctic is ESM-only and Jest runs CommonJS; Google sign-in isn't exercised here.
jest.mock("arctic", () => ({
  Google: class {},
  decodeIdToken: jest.fn(),
  generateCodeVerifier: jest.fn(),
  generateState: jest.fn(),
}));

// Boots the real AppModule with the production HTTP setup. None of these
// requests reach the database (the pg pool connects lazily), so no
// DATABASE_URL is needed.
describe("App (e2e)", () => {
  let app: NestExpressApplication;
  let server: App;

  beforeAll(async () => {
    process.env.NODE_ENV = "test";
    process.env.WEB_URL = "https://web.example.com";

    const moduleRef = await Test.createTestingModule({ imports: [AppModule] }).compile();
    app = moduleRef.createNestApplication<NestExpressApplication>();
    configureApp(app);
    await app.init();
    server = app.getHttpServer();
  });

  afterAll(() => app.close());

  it("GET / answers as a health check", () => {
    return request(server).get("/").expect(200).expect("Hello World!");
  });

  it("sets security headers", async () => {
    const res = await request(server).get("/").expect(200);
    expect(res.headers["x-content-type-options"]).toBe("nosniff");
    expect(res.headers["x-powered-by"]).toBeUndefined();
  });

  it("allows CORS only for the configured web origin", async () => {
    const allowed = await request(server).get("/").set("Origin", "https://web.example.com");
    expect(allowed.headers["access-control-allow-origin"]).toBe("https://web.example.com");

    const denied = await request(server).get("/").set("Origin", "https://evil.example.com");
    expect(denied.headers["access-control-allow-origin"]).toBeUndefined();
  });

  it("rejects protected routes without a session token", () => {
    return request(server).get("/account").expect(401);
  });

  it("requires a Turnstile token on public forms", () => {
    return request(server).post("/messages").send({}).expect(400);
  });
});
