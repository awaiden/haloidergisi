import { Link } from "@tanstack/react-router";
import { Menu } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetTrigger } from "@/components/ui/sheet";
import { useAuth } from "@/hooks/use-auth";
import { useNavbarStore } from "@/store/navbar-store";

import AccountDropdown from "../account-dropdown";
import Logo from "../logo";
import ThemeSwitcher from "../theme-switcher";

const items = [
  {
    url: "/posts",
    label: "Dergiler",
  },
  {
    url: "/about",
    label: "Hakkımızda",
  },
  {
    url: "/contact",
    label: "İletişim",
  },
  {
    url: "/team",
    label: "Ekibimiz",
  },
  {
    url: "/archive",
    label: "Arşiv",
  },
  {
    url: "/blog",
    label: "Blog",
  },
];

export default function LandingNavbar() {
  const { isOpen, setIsOpen } = useNavbarStore();

  const { data: user } = useAuth();

  return (
    <nav className='bg-background/95 supports-backdrop-filter:bg-background/60 sticky top-0 z-[70] w-full border-b backdrop-blur-sm'>
      <div className='container flex h-16 items-center justify-between px-4 md:px-8'>
        <div className='flex items-center gap-4'>
          <Sheet
            open={isOpen}
            onOpenChange={setIsOpen}
          >
            <SheetTrigger asChild>
              <Button
                variant='ghost'
                size='icon'
                className='md:hidden'
              >
                <Menu className='size-5' />
                <span className='sr-only'>Toggle menu</span>
              </Button>
            </SheetTrigger>
            <SheetContent
              side='left'
              className='flex w-[300px] flex-col px-6 sm:w-[400px]'
            >
              <SheetHeader className='border-b pb-6 text-left'>
                <SheetTitle>
                  <Logo className='h-10' />
                </SheetTitle>
              </SheetHeader>
              <div className='flex flex-1 flex-col gap-1 py-6'>
                {items.map((item) => (
                  <Link
                    key={item.url}
                    to={item.url}
                    className='hover:bg-accent hover:text-accent-foreground flex h-12 items-center rounded-lg px-4 text-base font-medium transition-colors'
                    onClick={() => setIsOpen(false)}
                  >
                    {item.label}
                  </Link>
                ))}

                <div className='mt-6 flex flex-col gap-3 border-t pt-6'>
                  {!user ? (
                    <>
                      <Button
                        variant='outline'
                        asChild
                        className='h-11 w-full justify-start px-4'
                      >
                        <Link
                          to='/login'
                          onClick={() => setIsOpen(false)}
                        >
                          Giriş Yap
                        </Link>
                      </Button>
                      <Button
                        asChild
                        className='h-11 w-full justify-start px-4'
                      >
                        <Link
                          to='/register'
                          onClick={() => setIsOpen(false)}
                        >
                          Kayıt Ol
                        </Link>
                      </Button>
                    </>
                  ) : (
                    <div className='bg-accent/50 mb-4 rounded-xl px-4 py-2'>
                      <p className='text-muted-foreground mb-1 text-xs'>Giriş Yapıldı</p>
                      <p className='truncate font-semibold'>{user.profile?.name || user.email}</p>
                    </div>
                  )}
                </div>
              </div>
              <div className='mt-auto flex items-center justify-between border-t px-2 pt-6 pb-6'>
                <span className='text-sm font-medium'>Görünüm</span>
                <ThemeSwitcher />
              </div>
            </SheetContent>
          </Sheet>
          <Link
            to='/'
            className='flex items-center'
          >
            <Logo className='h-12' />
          </Link>
        </div>

        <div className='hidden md:flex md:items-center md:gap-6'>
          {items.map((item) => (
            <Link
              key={item.url}
              to={item.url}
              className='hover:text-primary text-sm font-medium transition-colors'
            >
              {item.label}
            </Link>
          ))}
        </div>

        <div className='flex items-center gap-4'>
          {user && <AccountDropdown />}
          {!user && (
            <>
              <Button
                variant='ghost'
                asChild
                className='hidden md:flex'
              >
                <Link to='/login'>Giriş Yap</Link>
              </Button>
              <Button asChild>
                <Link to='/register'>Kayıt Ol</Link>
              </Button>
            </>
          )}
        </div>
      </div>
    </nav>
  );
}
