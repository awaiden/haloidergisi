import { Button } from "@adn-ui/react";
import { Icon } from "@iconify/react";
import { createFileRoute, Link, Outlet, useLocation } from "@tanstack/react-router";

import { Surface } from "@/components/chart-card";
import { useAuth } from "@/hooks/use-auth";

const tabs = [
  {
    label: "Hesap",
    icon: "mdi:account-circle-outline",
    href: "/account",
  },
  {
    label: "Profil",
    icon: "mdi:person-outline",
    href: "/account/profile",
  },
  {
    label: "Parola ve Güvenlik",
    icon: "mdi:shield-lock-outline",
    href: "/account/security",
  },
  {
    label: "Bağlı Uygulamalar",
    icon: "mdi:application-outline",
    href: "/account/applications",
  },
  {
    label: "Bildirimler",
    icon: "mdi:bell-outline",
    href: "/account/notifications",
  },
  {
    label: "Hesabı Sil",
    icon: "mdi:delete-outline",
    href: "/account/delete",
  },
];

export const Route = createFileRoute("/_landing/account")({
  component: RouteComponent,
});

function RouteComponent() {
  const { pathname } = useLocation();
  const { data: user } = useAuth();

  if (!user) return null;

  const isActive = (path: string) => pathname === path;

  return (
    <div className='from-background via-background to-muted/20 min-h-screen bg-linear-to-br'>
      <div className='container max-w-7xl px-4 py-16'>
        {/* Header */}
        <div className='mb-12'>
          <h1 className='mb-3 text-4xl font-bold tracking-tight'>Hesap Ayarları</h1>
          <p className='text-muted-foreground text-lg'>
            Hoş geldiniz, <span className='text-foreground font-medium'>{user.profile?.name}</span>
          </p>
        </div>

        <div className='grid grid-cols-12 gap-4'>
          <div className='col-span-12 md:col-span-3'>
            <Surface>
              <ul className='space-y-2'>
                {tabs.map((tab) => (
                  <li key={tab.href}>
                    <Button
                      render={<Link to={tab.href} />}
                      variant={isActive(tab.href) ? "primary" : "ghost"}
                      className='w-full justify-start font-normal'
                    >
                      <Icon icon={tab.icon} />
                      {tab.label}
                    </Button>
                  </li>
                ))}
              </ul>
            </Surface>
          </div>
          <div className='col-span-12 md:col-span-9'>
            <Surface className='p-6'>
              <Outlet />
            </Surface>
          </div>
        </div>
      </div>
    </div>
  );
}
