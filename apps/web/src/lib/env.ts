/**
 * Public runtime config. Vite inlines `VITE_*` values at build time, and the
 * root `.env` is shared by dev and production builds, so a production build
 * never trusts a local-only value: it falls back to the production endpoints.
 */
export const PRODUCTION_API_URL = "https://api.haloidergisi.com";
export const DEV_API_URL = "http://localhost:3000";
/** Public site key (it ships in every bundle); the mobile app defaults to it too. */
export const PRODUCTION_TURNSTILE_SITE_KEY = "0x4AAAAAACN8voBpRMLOZ9Nu";

const LOOPBACK_HOSTS = new Set(["localhost", "127.0.0.1", "0.0.0.0", "[::1]", "10.0.2.2"]);

function isLocalUrl(value: string): boolean {
  try {
    const { hostname } = new URL(value);
    return LOOPBACK_HOSTS.has(hostname) || hostname.endsWith(".localhost");
  } catch {
    return true;
  }
}

export function resolveApiUrl(value: string | undefined, isProduction: boolean): string {
  const url = value?.trim().replace(/\/+$/, "");
  if (!url) return isProduction ? PRODUCTION_API_URL : DEV_API_URL;
  if (isProduction && isLocalUrl(url)) return PRODUCTION_API_URL;
  return url;
}

/** Cloudflare's test keys (1x…, 2x…, 3x…) never belong in a production build. */
export function resolveTurnstileSiteKey(value: string | undefined, isProduction: boolean): string {
  const key = value?.trim() ?? "";
  if (isProduction && (!key || /^[123]x0{10,}/.test(key))) return PRODUCTION_TURNSTILE_SITE_KEY;
  return key;
}

export const API_URL = resolveApiUrl(import.meta.env.VITE_API_URL, import.meta.env.PROD);
export const TURNSTILE_SITE_KEY = resolveTurnstileSiteKey(
  import.meta.env.VITE_TURNSTILE_SITE_KEY,
  import.meta.env.PROD,
);
