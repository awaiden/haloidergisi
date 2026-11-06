import { describe, expect, it } from "vitest";

import { looksLikePdf } from "./issue-cache";

const bytes = (s: string) => new TextEncoder().encode(s);

describe("looksLikePdf", () => {
  it("accepts a PDF header", () => expect(looksLikePdf(bytes("%PDF-1.7\n..."))).toBe(true));
  it("accepts junk before the header", () =>
    expect(looksLikePdf(bytes("junk\n".repeat(50) + "%PDF-1.4"))).toBe(true));
  it("rejects an HTML page", () =>
    expect(looksLikePdf(bytes("<!doctype html><title>Just a moment</title>"))).toBe(false));
});
