import "@fontsource/poppins";
import { TanStackDevtools } from "@tanstack/react-devtools";
import { HeadContent, Scripts, createRootRoute } from "@tanstack/react-router";
import { TanStackRouterDevtoolsPanel } from "@tanstack/react-router-devtools";
import { useEffect } from "react";
import { Toaster } from "sonner";

import LoadingIndicator from "@/components/loading-indicator";
import AnalyticsTracker from "@/components/tracker";
import { SITE_URL } from "@/lib/env";
import AppProviders from "@/providers";

import appCss from "../styles.css?url";
import { ErrorComponent } from "./-error";
import { NotFound } from "./-not-found";

export const Route = createRootRoute({
  notFoundComponent: NotFound,
  errorComponent: ErrorComponent,
  head: () => ({
    meta: [
      {
        charSet: "utf-8",
      },
      {
        name: "viewport",
        content: "width=device-width, initial-scale=1, viewport-fit=cover",
      },
      {
        title: "HALO Dergisi - Aylık Fikir, Sanat ve Edebiyat Dergisi",
      },
      {
        name: "description",
        content:
          "HALO Dergisi, fikir, sanat ve edebiyat alanlarında özgün içerikler sunan aylık bir öğrenci dergisidir. Dergilerimize göz atın, blog yazılarımızı okuyun.",
      },
      {
        name: "keywords",
        content: "HALO Dergisi, edebiyat dergisi, sanat, fikir, öğrenci dergisi, dergi arşivi",
      },
      {
        name: "author",
        content: "HALO Dergisi Editörleri",
      },
      {
        property: "og:type",
        content: "website",
      },
      {
        property: "og:site_name",
        content: "HALO Dergisi",
      },
      {
        property: "og:title",
        content: "HALO Dergisi - Aylık Fikir, Sanat ve Edebiyat Dergisi",
      },
      {
        property: "og:description",
        content:
          "HALO Dergisi, fikir, sanat ve edebiyat alanlarında özgün içerikler sunan aylık bir öğrenci dergisidir.",
      },
      {
        property: "og:image",
        content: `${SITE_URL}/logo.png`,
      },
      {
        property: "og:locale",
        content: "tr_TR",
      },
      {
        name: "twitter:card",
        content: "summary_large_image",
      },
      {
        name: "twitter:title",
        content: "HALO Dergisi - Aylık Fikir, Sanat ve Edebiyat Dergisi",
      },
      {
        name: "twitter:description",
        content:
          "HALO Dergisi, fikir, sanat ve edebiyat alanlarında özgün içerikler sunan aylık bir öğrenci dergisidir.",
      },
      {
        name: "twitter:image",
        content: `${SITE_URL}/logo.png`,
      },
      {
        name: "theme-color",
        content: "#000000",
      },
    ],
    scripts: [
      {
        src: "https://challenges.cloudflare.com/turnstile/v0/api.js?render=explicit",
        async: true,
        defer: true,
      },
    ],
    links: [
      {
        rel: "stylesheet",
        href: appCss,
      },
      {
        rel: "icon",
        href: "/logo.png",
      },
      {
        rel: "apple-touch-icon",
        href: "/apple-touch-icon.png",
      },
      {
        rel: "manifest",
        href: "/manifest.webmanifest",
      },
    ],
  }),

  shellComponent: RootDocument,
});

function RootDocument({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    if (import.meta.env.PROD)
      import("virtual:pwa-register").then((m) => m.registerSW({ immediate: true }));
  }, []);

  return (
    <html
      lang='tr'
      suppressHydrationWarning
    >
      <head>
        <HeadContent />
      </head>
      <body>
        <AppProviders>
          <LoadingIndicator />
          {children}
          <Toaster richColors />
          <AnalyticsTracker />
        </AppProviders>
        <TanStackDevtools
          config={{
            position: "bottom-right",
          }}
          plugins={[
            {
              name: "Tanstack Router",
              render: <TanStackRouterDevtoolsPanel />,
            },
          ]}
        />
        <Scripts />
      </body>
    </html>
  );
}
