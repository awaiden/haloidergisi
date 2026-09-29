import type { PageVisit } from "@/types";

/**
 * Gets top N visited pages
 */
export function getTopPages(visits: PageVisit[], limit = 10) {
  const pageVisits = visits.reduce(
    (acc, visit) => {
      if (!acc[visit.url]) {
        acc[visit.url] = 0;
      }
      acc[visit.url] += visit.count;
      return acc;
    },
    {} as Record<string, number>,
  );

  return Object.entries(pageVisits)
    .map(([url, count]) => ({ url, count }))
    .sort((a, b) => b.count - a.count)
    .slice(0, limit);
}

/**
 * Categorizes page visits by type (posts vs other)
 */
export function categorizePageVisits(visits: PageVisit[]) {
  const categories = {
    posts: 0,
    other: 0,
  };

  visits.forEach((visit) => {
    if (visit.url.startsWith("/posts/")) {
      categories.posts += visit.count;
    } else {
      categories.other += visit.count;
    }
  });

  return [
    { name: "Yazılar", value: categories.posts },
    { name: "Diğer Sayfalar", value: categories.other },
  ];
}

/**
 * Calculate percentage change between two numbers
 */
export function calculatePercentageChange(current: number, previous: number): number {
  if (previous === 0) return current > 0 ? 100 : 0;
  return ((current - previous) / previous) * 100;
}

/**
 * Format large numbers with K/M suffix
 */
export function formatNumber(num: number): string {
  if (num >= 1000000) {
    return `${(num / 1000000).toFixed(1)}M`;
  }
  if (num >= 1000) {
    return `${(num / 1000).toFixed(1)}K`;
  }
  return num.toString();
}
