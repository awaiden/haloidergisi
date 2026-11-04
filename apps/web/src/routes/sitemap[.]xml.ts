import { createFileRoute } from "@tanstack/react-router";

import { API_URL } from "@/lib/env";

export const Route = createFileRoute("/sitemap.xml")({
  server: {
    handlers: {
      GET: async () => {
        const res = await fetch(`${API_URL}/sitemap/xml`);
        return new Response(await res.text(), {
          status: res.status,
          headers: {
            "Content-Type": "application/xml; charset=utf-8",
            "Cache-Control": "public, max-age=3600",
          },
        });
      },
    },
  },
});
