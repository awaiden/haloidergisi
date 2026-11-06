import type { CorsOptions } from "@nestjs/common/interfaces/external/cors-options.interface";

/**
 * Browser origins allowed to call the API.
 *
 * `CORS_ORIGINS` (comma-separated) wins when set; otherwise the web app's
 * `WEB_URL` / `APP_URL` / `FRONTEND_URL` are used, each with its `www.`
 * counterpart. Outside production the Vite dev server is always allowed.
 * Requests without an `Origin` header (mobile app, server-side rendering,
 * curl) are not affected by CORS.
 */
export function resolveCorsOrigins(env: NodeJS.ProcessEnv = process.env): string[] {
  const configured = env.CORS_ORIGINS?.split(",") ?? [env.WEB_URL, env.APP_URL, env.FRONTEND_URL];

  const origins = new Set<string>();
  for (const value of configured) {
    const origin = toOrigin(value);
    if (!origin) continue;
    origins.add(origin);
    if (!env.CORS_ORIGINS) {
      const alternate = wwwCounterpart(origin);
      if (alternate) origins.add(alternate);
    }
  }

  if (env.NODE_ENV !== "production") {
    origins.add("http://localhost:5173");
    origins.add("http://127.0.0.1:5173");
  }

  return [...origins];
}

export function buildCorsOptions(env: NodeJS.ProcessEnv = process.env): CorsOptions {
  const origins = resolveCorsOrigins(env);
  if (origins.length === 0) {
    console.warn(
      "CORS: no allowed origins configured (set CORS_ORIGINS or WEB_URL/APP_URL); allowing any origin.",
    );
    return { origin: true };
  }
  return { origin: origins };
}

function toOrigin(value: string | undefined): string | null {
  if (!value?.trim()) return null;
  try {
    return new URL(value.trim()).origin;
  } catch {
    return null;
  }
}

function wwwCounterpart(origin: string): string | null {
  const url = new URL(origin);
  if (url.hostname === "localhost" || /^[\d.]+$/.test(url.hostname)) return null;
  url.hostname = url.hostname.startsWith("www.") ? url.hostname.slice(4) : `www.${url.hostname}`;
  return url.origin;
}
