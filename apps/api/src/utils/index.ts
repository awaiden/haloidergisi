export * from "./query-builder";

export const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));
