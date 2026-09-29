import { describe, expect, it } from "vitest";

import {
  DEV_API_URL,
  PRODUCTION_API_URL,
  PRODUCTION_TURNSTILE_SITE_KEY,
  resolveApiUrl,
  resolveTurnstileSiteKey,
} from "./env";

describe("resolveApiUrl", () => {
  it("uses the configured URL, without a trailing slash", () => {
    expect(resolveApiUrl("https://staging.example.com/", true)).toBe("https://staging.example.com");
    expect(resolveApiUrl("http://localhost:4000", false)).toBe("http://localhost:4000");
  });

  it("defaults per build mode when unset", () => {
    expect(resolveApiUrl(undefined, false)).toBe(DEV_API_URL);
    expect(resolveApiUrl("", true)).toBe(PRODUCTION_API_URL);
  });

  it("never lets a production build point at a local API", () => {
    for (const local of [
      "http://localhost:3000",
      "http://127.0.0.1:3000",
      "http://10.0.2.2:3000",
      "http://api.localhost",
      "not a url",
    ]) {
      expect(resolveApiUrl(local, true)).toBe(PRODUCTION_API_URL);
    }
  });
});

describe("resolveTurnstileSiteKey", () => {
  it("replaces missing or Cloudflare test keys in production", () => {
    expect(resolveTurnstileSiteKey(undefined, true)).toBe(PRODUCTION_TURNSTILE_SITE_KEY);
    expect(resolveTurnstileSiteKey("1x00000000000000000000AA", true)).toBe(
      PRODUCTION_TURNSTILE_SITE_KEY,
    );
    expect(resolveTurnstileSiteKey("1x00000000000000000000AA", false)).toBe(
      "1x00000000000000000000AA",
    );
    expect(resolveTurnstileSiteKey("0xCUSTOM", true)).toBe("0xCUSTOM");
  });
});
