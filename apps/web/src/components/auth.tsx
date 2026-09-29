import { Icon } from "@iconify/react";
import { toast } from "sonner";

import { Button } from "@/components/ui/button";
import apiClient from "@/lib/api-client";

const API_URL = import.meta.env.VITE_API_URL || "http://localhost:3000";

interface GoogleAuthButtonProps extends React.ComponentProps<typeof Button> {
  action?: "login" | "link";
}

/**
 * Starts the API's Google redirect flow (arctic, see `AuthGoogleService`).
 * The browser comes back to `/google-callback` with a one-time code.
 */
export const GoogleAuthButton = ({ action = "login", ...props }: GoogleAuthButtonProps) => {
  const start = async () => {
    if (action === "login") {
      window.location.assign(`${API_URL}/auth/google?platform=web`);
      return;
    }
    try {
      const { data } = await apiClient.post<{ url: string }>("/auth/google/link", {
        platform: "web",
      });
      window.location.assign(data.url);
    } catch (error) {
      toast.error(apiClient.resolveApiError(error).message);
    }
  };

  return (
    <Button
      variant='outline'
      {...props}
      onClick={start}
    >
      <Icon icon='flat-color-icons:google' />
      Google ile Devam Et
    </Button>
  );
};
