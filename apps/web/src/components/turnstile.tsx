import React from "react";

import { cn } from "@/lib/utils";

interface TurnstileProps extends React.HTMLAttributes<HTMLDivElement> {
  onVerify: (token: string) => void;
  /** Called with no token when the current one expires or the check fails. */
  onExpire?: () => void;
}

/**
 * Cloudflare Turnstile that verifies automatically: with
 * `appearance: "interaction-only"` the widget stays hidden and only shows up
 * when Cloudflare needs the visitor to interact. Expired tokens refresh on
 * their own.
 */

export function Turnstile({ onVerify, onExpire, className, ...props }: TurnstileProps) {
  const widgetRef = React.useRef<HTMLDivElement>(null);
  const onVerifyRef = React.useRef(onVerify);
  const onExpireRef = React.useRef(onExpire);

  React.useEffect(() => {
    onVerifyRef.current = onVerify;
    onExpireRef.current = onExpire;
  }, [onVerify, onExpire]);

  React.useEffect(() => {
    if (!widgetRef.current) return;

    const widgetId = window.turnstile?.render(widgetRef.current, {
      sitekey: import.meta.env.VITE_TURNSTILE_SITE_KEY,
      appearance: "interaction-only",
      "refresh-expired": "auto",
      language: "tr",
      callback: (token: string) => {
        onVerifyRef.current(token);
      },
      "expired-callback": () => onExpireRef.current?.(),
      "error-callback": () => onExpireRef.current?.(),
    });

    return () => {
      window.turnstile?.remove(widgetId!);
    };
  }, []);

  return (
    <div
      ref={widgetRef}
      className={cn("mx-auto", className)}
      {...props}
    />
  );
}
