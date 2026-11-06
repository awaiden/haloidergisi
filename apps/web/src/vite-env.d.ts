/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_TURNSTILE_SITE_KEY: string;
  readonly VITE_API_URL: string;
  readonly VITE_CDN_URL: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}

interface Window {
  turnstile: Turnstile.Turnstile;
}

declare module "@fontsource/poppins";
