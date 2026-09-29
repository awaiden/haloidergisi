import { describe, expect, it } from "vitest";

import type { PageVisit } from "@/types";

import { calculatePercentageChange, formatNumber, getTopPages } from "./chart-helpers";

describe("formatNumber", () => {
  it("abbreviates thousands and millions", () => {
    expect(formatNumber(999)).toBe("999");
    expect(formatNumber(1500)).toBe("1.5K");
    expect(formatNumber(2_000_000)).toBe("2.0M");
  });
});

describe("calculatePercentageChange", () => {
  it("handles a zero baseline", () => {
    expect(calculatePercentageChange(5, 0)).toBe(100);
    expect(calculatePercentageChange(0, 0)).toBe(0);
  });

  it("computes the relative change", () => {
    expect(calculatePercentageChange(150, 100)).toBe(50);
    expect(calculatePercentageChange(50, 100)).toBe(-50);
  });
});

describe("getTopPages", () => {
  it("sums visits per URL and returns the busiest first", () => {
    const visits = [
      { url: "/a", count: 1 },
      { url: "/b", count: 5 },
      { url: "/a", count: 3 },
      { url: "/c", count: 2 },
    ] as PageVisit[];
    expect(getTopPages(visits, 2)).toEqual([
      { url: "/b", count: 5 },
      { url: "/a", count: 4 },
    ]);
  });
});
