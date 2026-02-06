import { Button } from "@adn-ui/react";
import { Icon } from "@iconify/react";
import { Link, useRouter } from "@tanstack/react-router";

export function ErrorComponent({ error }: { error: Error }) {
  const router = useRouter();

  return (
    <div className='bg-background flex min-h-screen flex-col items-center justify-center p-4 text-center'>
      <div className='flex max-w-md flex-col items-center gap-6'>
        <div className='bg-destructive/10 flex h-24 w-24 items-center justify-center rounded-full'>
          <Icon
            icon='mdi:alert-circle-outline'
            className='text-destructive h-12 w-12'
          />
        </div>

        <div className='space-y-2'>
          <h1 className='text-2xl font-bold tracking-tight'>Bir Hata Oluştu</h1>
          <p className='text-muted-foreground'>
            Beklenmedik bir sorunla karşılaştık. Lütfen tekrar deneyin.
          </p>
          {import.meta.env.DEV && (
            <div className='bg-muted mt-4 max-h-40 overflow-auto rounded p-2 text-left font-mono text-xs'>
              {error.message}
            </div>
          )}
        </div>

        <div className='flex gap-4'>
          <Button
            variant='outline'
            onClick={() => router.invalidate()}
            className='gap-2'
          >
            <Icon
              icon='mdi:refresh'
              className='h-4 w-4'
            />
            Tekrar Dene
          </Button>

          <Link to='/'>
            <Button className='gap-2'>Ana Sayfaya Dön</Button>
          </Link>
        </div>
      </div>
    </div>
  );
}
