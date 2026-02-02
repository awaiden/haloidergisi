import { Separator, Button } from "@adn-ui/react";
import { NotificationSettings } from "@repo/db";
import { useQueryClient, useQuery, useMutation } from "@tanstack/react-query";
import { createFileRoute } from "@tanstack/react-router";
import { toast } from "sonner";

import apiClient from "@/lib/api-client";

export const Route = createFileRoute("/_landing/account/notifications")({
  component: RouteComponent,
});

function RouteComponent() {
  return (
    <div className='space-y-6'>
      <div>
        <h2 className='mb-2 text-2xl font-semibold'>Bildirim Ayarları</h2>
        <p className='text-muted-foreground'>Bildirim tercihlerinizi yönetin.</p>
      </div>
      <Separator />
      <NotificationSettingsForm />
    </div>
  );
}

function NotificationSettingsForm() {
  const queryClient = useQueryClient();
  const queryKey = ["notification-settings"];

  const { data: settings, isLoading } = useQuery<NotificationSettings>({
    queryKey,
    queryFn: async () => (await apiClient.get("/account/notification-settings")).data,
  });

  const mutation = useMutation({
    mutationFn: async (payload: Partial<NotificationSettings>) => {
      return (await apiClient.patch("/account/notification-settings", payload)).data;
    },
    onMutate: async (newSetting) => {
      await queryClient.cancelQueries({ queryKey });
      const previousSettings = queryClient.getQueryData<NotificationSettings>(queryKey);

      queryClient.setQueryData(queryKey, (old: any) => ({ ...old, ...newSetting }));

      return { previousSettings };
    },
    onError: (_err, _newSetting, context) => {
      queryClient.setQueryData(queryKey, context?.previousSettings);
      toast.error("Güncelleme başarısız oldu.");
    },
    onSettled: async () => {
      await queryClient.invalidateQueries({ queryKey });
    },
    onSuccess: () => {
      toast.success("Bildirim ayarlarınız güncellendi.");
    },
  });

  if (isLoading || !settings) return <p>Yükleniyor...</p>;

  return (
    <div className='space-y-4'>
      <div className='flex items-center justify-between'>
        <h3 className='font-medium'>E-posta Bildirimleri</h3>
        <Button
          variant={settings.emailNotifications ? "primary" : "outline"}
          onClick={() => mutation.mutate({ emailNotifications: !settings.emailNotifications })}
          disabled={mutation.isPending}
        >
          {settings.emailNotifications ? "Açık" : "Kapalı"}
        </Button>
      </div>

      <Separator />

      <div className='flex items-center justify-between'>
        <h3 className='font-medium'>Yeni Dergi Bildirimleri</h3>
        <Button
          variant={settings.newPost ? "primary" : "outline"}
          onClick={() => mutation.mutate({ newPost: !settings.newPost })}
        >
          {settings.newPost ? "Açık" : "Kapalı"}
        </Button>
      </div>

      <div className='flex items-center justify-between'>
        <h3 className='font-medium'>Güvenlik Bildirimleri</h3>
        <Button
          variant={settings.securityAlert ? "primary" : "outline"}
          onClick={() => mutation.mutate({ securityAlert: !settings.securityAlert })}
        >
          {settings.securityAlert ? "Açık" : "Kapalı"}
        </Button>
      </div>
    </div>
  );
}
