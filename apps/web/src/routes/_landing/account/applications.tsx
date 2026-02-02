import { Separator, Button } from "@adn-ui/react";
import { Icon } from "@iconify/react";
import { Provider } from "@repo/db";
import { useQuery } from "@tanstack/react-query";
import { createFileRoute } from "@tanstack/react-router";
import { toast } from "sonner";

import { GoogleAuthButton } from "@/components/auth";
import apiClient from "@/lib/api-client";
import { queryClient } from "@/lib/query-client";

export const Route = createFileRoute("/_landing/account/applications")({
  component: RouteComponent,
});

function RouteComponent() {
  const { data: providers, isLoading } = useQuery({
    queryKey: ["account-providers"],
    queryFn: async () => {
      const { data } = await apiClient.get<Provider[]>("/account/providers");
      return data;
    },
  });

  const handleDisconnect = async (providerId: string) => {
    try {
      await apiClient.delete(`/account/providers/${providerId}`);
      toast.success("Hesap bağlantısı başarıyla kaldırıldı.");
      await queryClient.invalidateQueries({ queryKey: ["account-providers"] });
    } catch (error) {
      console.error(error);
      toast.error(apiClient.resolveApiError(error).message);
    }
  };

  const getProviderIcon = (provider: string) => {
    switch (provider) {
      case "GOOGLE":
        return "flat-color-icons:google";
      default:
        return "mdi:account";
    }
  };

  const getProviderName = (provider: string) => {
    switch (provider) {
      case "GOOGLE":
        return "Google";
      default:
        return provider;
    }
  };

  const hasGoogleProvider = providers?.some((p) => p.provider === "GOOGLE") ?? false;

  if (isLoading) {
    return (
      <div className='space-y-6'>
        <div>
          <h2 className='mb-2 text-2xl font-semibold'>Bağlı Hesaplar</h2>
          <p className='text-muted-foreground text-sm'>Yükleniyor...</p>
        </div>
      </div>
    );
  }

  return (
    <div className='space-y-6'>
      <div>
        <h2 className='mb-2 text-2xl font-semibold'>Bağlı Hesaplar</h2>
        <p className='text-muted-foreground text-sm'>Üçüncü taraf hesaplarınızı yönetin.</p>
      </div>

      <Separator />

      {/* Connected Providers */}
      {providers && providers.length > 0 && (
        <div className='space-y-4'>
          <h3 className='font-semibold'>Bağlı Hesaplar</h3>
          <div className='space-y-3'>
            {providers.map((provider) => (
              <div
                key={provider.id}
                className='border-border bg-muted/30 group hover:border-primary/50 flex items-center justify-between rounded-lg border p-5 transition-all hover:shadow-sm'
              >
                <div className='flex items-center gap-4'>
                  <div className='bg-background flex h-12 w-12 items-center justify-center rounded-full'>
                    <Icon
                      icon={getProviderIcon(provider.provider)}
                      className='text-3xl'
                    />
                  </div>
                  <div>
                    <p className='font-semibold'>{getProviderName(provider.provider)}</p>
                    <p className='text-muted-foreground text-sm'>Bağlı hesap</p>
                  </div>
                </div>
                <Button
                  variant='outline'
                  size='sm'
                  onClick={() => handleDisconnect(provider.id)}
                  className='gap-2'
                >
                  <Icon icon='mdi:link-off' />
                  Bağlantıyı Kaldır
                </Button>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Available Providers to Connect */}
      <div className='space-y-4'>
        <h3 className='font-semibold'>Hesap Bağla</h3>
        <div>
          {!hasGoogleProvider ? (
            <GoogleAuthButton
              action='link'
              className='w-full'
            />
          ) : (
            <div className='bg-muted/30 border-border rounded-lg border p-4 text-center'>
              <p className='text-muted-foreground text-sm'>Tüm mevcut hesaplar bağlandı.</p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
