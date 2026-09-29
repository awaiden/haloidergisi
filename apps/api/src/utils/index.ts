export * from "./query-builder";
export * from "./drizzle";

/** Keeps only the allowed keys of a `fields` include (see `parseFields`). */
export function pickRelations<K extends string>(
  include: Record<string, true> | undefined,
  allowed: readonly K[],
): Partial<Record<K, true>> {
  return Object.fromEntries(
    allowed.filter((key) => include?.[key]).map((key) => [key, true] as const),
  ) as Partial<Record<K, true>>;
}

export const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));
