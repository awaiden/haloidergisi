import { buildCorsOptions, resolveCorsOrigins } from "./cors";

describe("resolveCorsOrigins", () => {
  it("uses the web app URLs and their www counterparts in production", () => {
    const origins = resolveCorsOrigins({
      NODE_ENV: "production",
      APP_URL: "https://haloidergisi.com/",
    });
    expect(origins).toEqual(["https://haloidergisi.com", "https://www.haloidergisi.com"]);
  });

  it("prefers CORS_ORIGINS verbatim when set", () => {
    const origins = resolveCorsOrigins({
      NODE_ENV: "production",
      CORS_ORIGINS: "https://a.example.com, https://b.example.com/path",
      APP_URL: "https://ignored.example.com",
    });
    expect(origins).toEqual(["https://a.example.com", "https://b.example.com"]);
  });

  it("allows the Vite dev server outside production and skips invalid values", () => {
    const origins = resolveCorsOrigins({ WEB_URL: "http://localhost:5173", APP_URL: "not a url" });
    expect(origins).toEqual(["http://localhost:5173", "http://127.0.0.1:5173"]);
  });
});

describe("buildCorsOptions", () => {
  it("falls back to any origin when nothing is configured", () => {
    const warn = jest.spyOn(console, "warn").mockImplementation(() => undefined);
    expect(buildCorsOptions({ NODE_ENV: "production" })).toEqual({ origin: true });
    expect(warn).toHaveBeenCalled();
    warn.mockRestore();
  });
});
