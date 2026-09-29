import { Icon } from "@iconify/react";
import { createFileRoute, useRouter } from "@tanstack/react-router";
import { useEffect, useRef } from "react";
import { toast } from "sonner";

import apiClient from "@/lib/api-client";

export const Route = createFileRoute("/_auth/google-callback")({
  component: RouteComponent,
});

/**
 * Landing page of the Google flow. The API puts `code`, `linked` or `error`
 * in the URL fragment; a code is traded for a session token.
 */
function RouteComponent() {
  const router = useRouter();
  const handled = useRef(false);

  useEffect(() => {
    if (handled.current) return;
    handled.current = true;

    const params = new URLSearchParams(window.location.hash.slice(1));
    // Drop the one-time code from the address bar and history.
    window.history.replaceState(null, "", window.location.pathname);

    const run = async () => {
      const error = params.get("error");
      if (error) {
        toast.error(error);
        await router.navigate({ to: "/login" });
        return;
      }
      if (params.get("linked") === "1") {
        toast.success("Google hesabınız başarıyla bağlandı.");
        await router.navigate({ to: "/account/applications" });
        return;
      }
      const code = params.get("code");
      if (!code) {
        await router.navigate({ to: "/login" });
        return;
      }
      try {
        const { data } = await apiClient.post<{ token: string }>("/auth/google/exchange", { code });
        localStorage.setItem("token", data.token);
        toast.success("Giriş başarılı!");
        await router.navigate({ to: "/" });
      } catch (err) {
        toast.error(apiClient.resolveApiError(err).message);
        await router.navigate({ to: "/login" });
      }
    };
    void run();
  }, [router]);

  return (
    <div className='text-muted-foreground grid min-h-screen place-items-center'>
      <div className='flex items-center gap-2'>
        <Icon
          icon='mdi:loading'
          className='animate-spin text-xl'
        />
        Google ile giriş yapılıyor…
      </div>
    </div>
  );
}
