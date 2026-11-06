import { Link } from "@tanstack/react-router";
import { BookOpen, Megaphone, Newspaper, User } from "lucide-react";

const tabs = [
  { to: "/posts", label: "Dergiler", icon: BookOpen },
  { to: "/blog", label: "Blog", icon: Newspaper },
  { to: "/articles", label: "Çağrılar", icon: Megaphone },
  { to: "/account", label: "Hesap", icon: User },
] as const;

export default function BottomTabs() {
  return (
    <nav className='bg-background/95 fixed inset-x-0 bottom-0 z-[70] border-t pb-[env(safe-area-inset-bottom)] backdrop-blur-sm md:hidden'>
      <ul className='grid h-14 grid-cols-4'>
        {tabs.map(({ to, label, icon: TabIcon }) => (
          <li key={to}>
            <Link
              to={to}
              search={to === "/posts" ? {} : undefined}
              className='text-muted-foreground flex h-full flex-col items-center justify-center gap-0.5 text-xs'
              activeProps={{ className: "text-primary font-medium" }}
            >
              <TabIcon className='size-5' />
              {label}
            </Link>
          </li>
        ))}
      </ul>
    </nav>
  );
}
