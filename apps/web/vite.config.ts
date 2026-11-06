import tailwindcss from "@tailwindcss/vite";
import { devtools } from "@tanstack/devtools-vite";
import { tanstackStart } from "@tanstack/react-start/plugin/vite";
import viteReact from "@vitejs/plugin-react";
import { nitro } from "nitro/vite";
import { defineConfig } from "vite";
import { VitePWA } from "vite-plugin-pwa";
import viteTsConfigPaths from "vite-tsconfig-paths";

const config = defineConfig({
  plugins: [
    devtools(),
    viteTsConfigPaths({
      projects: ["./tsconfig.json"],
    }),
    tailwindcss(),
    tanstackStart(),
    nitro(),
    viteReact(),
    VitePWA({
      outDir: ".output/public",
      registerType: "autoUpdate",
      injectRegister: null,
      manifest: {
        name: "HALO Dergisi - Aylık Fikir, Sanat ve Edebiyat Dergisi",
        short_name: "HALO",
        description:
          "HALO Dergisi, öğrenciler tarafından hazırlanan aylık fikir, sanat ve edebiyat dergisidir.",
        lang: "tr",
        start_url: "/",
        display: "standalone",
        orientation: "portrait-primary",
        theme_color: "#000000",
        background_color: "#ffffff",
        categories: ["education", "lifestyle", "magazines"],
        icons: [
          { src: "/pwa-192.png", sizes: "192x192", type: "image/png" },
          { src: "/pwa-512.png", sizes: "512x512", type: "image/png" },
          {
            src: "/pwa-maskable-512.png",
            sizes: "512x512",
            type: "image/png",
            purpose: "maskable",
          },
        ],
      },
      workbox: {
        // SSR: there is no static shell HTML to fall back to.
        navigateFallback: null,
        globPatterns: ["**/*.{js,css,woff2,svg,png,webp}"],
        runtimeCaching: [
          {
            urlPattern: ({ request }) => request.mode === "navigate",
            handler: "NetworkFirst",
            options: { cacheName: "halo-pages", expiration: { maxEntries: 50 } },
          },
          {
            urlPattern: ({ url, request }) =>
              request.method === "GET" && url.pathname.startsWith("/posts"),
            handler: "NetworkFirst",
            options: { cacheName: "halo-api", expiration: { maxEntries: 50 } },
          },
        ],
      },
    }),
  ],
});

export default config;
