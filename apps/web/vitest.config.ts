import viteReact from "@vitejs/plugin-react";
import viteTsConfigPaths from "vite-tsconfig-paths";
import { defineConfig } from "vitest/config";

// Kept separate from vite.config.ts: the TanStack Start, nitro and devtools
// plugins start servers that keep Vitest from exiting.
export default defineConfig({
  plugins: [viteTsConfigPaths({ projects: ["./tsconfig.json"] }), viteReact()],
  test: {
    environment: "jsdom",
    include: ["src/**/*.test.{ts,tsx}"],
  },
});
