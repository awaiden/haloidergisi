import { afterEach, describe, expect, it, vi } from "vitest";

import { getCdnUrl } from "./cdn";

describe("getCdnUrl", () => {
  afterEach(() => vi.unstubAllEnvs());

  it("returns an empty string for missing paths", () => {
    expect(getCdnUrl()).toBe("");
    expect(getCdnUrl(null)).toBe("");
  });

  it("leaves absolute URLs untouched", () => {
    expect(getCdnUrl("https://example.com/a.png")).toBe("https://example.com/a.png");
  });

  it("resolves keys against the configured CDN and encodes them", () => {
    vi.stubEnv("VITE_CDN_URL", "https://cdn.test/base");
    expect(getCdnUrl("covers/sayı 1.png")).toBe("https://cdn.test/base/covers/say%C4%B1%201.png");
  });
});
