import { describe, expect, it, vi } from "vitest";

import { getLastPage, saveLastPage } from "./reading-progress";

describe("reading progress", () => {
  const store = new Map<string, string>();
  vi.stubGlobal("localStorage", {
    getItem: (k: string) => store.get(k) ?? null,
    setItem: (k: string, v: string) => void store.set(k, v),
  });

  it("round-trips per slug", () => {
    expect(getLastPage("a")).toBeNull();
    saveLastPage("a", 7);
    expect(getLastPage("a")).toBe(7);
    expect(getLastPage("b")).toBeNull();
  });
});
