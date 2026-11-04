import { createFileRoute } from "@tanstack/react-router";
import { motion } from "motion/react";

import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import apiClient from "@/lib/api-client";
import { Crew, List, User } from "@/types";
import { getCdnUrl } from "@/utils/cdn";
import { pageHead } from "@/utils/seo";

export const Route = createFileRoute("/_landing/team")({
  head: () =>
    pageHead("/team", "Ekibimiz", "HALO Dergisi'ni hazırlayan editörler ve ekip üyeleri."),
  component: RouteComponent,
  loader: async () => {
    const { data: crews } = await apiClient.get<List<Crew>>("/crews");

    return {
      crews: {
        ...crews,
        items: crews.items.sort((a, b) => a.sort - b.sort),
      },
    };
  },
});

function RouteComponent() {
  const { crews } = Route.useLoaderData();

  return (
    <section className='container py-20'>
      <h2 className='text-3xl font-bold'>Ekibimiz</h2>
      <p className='text-muted-foreground'>
        HALO ekibini burada bulabilir ve kartlara tıklayarak kişiler hakkında daha fazla bilgi
        edinebilirsiniz!
      </p>
      <br />

      <div className='space-y-20'>
        {crews.items.map((crew) => (
          <div key={crew.id}>
            <h3 className='mb-4 text-2xl font-semibold'>{crew.name}</h3>
            <div className='grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3'>
              {crew.users?.map((user) => (
                <UserCard
                  key={user.id}
                  {...user}
                />
              ))}
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}

function UserCard(user: User) {
  return (
    <Dialog>
      <DialogTrigger asChild>
        <motion.div
          whileHover={{ scale: 1.05 }}
          className='cursor-pointer'
        >
          <div className='bg-surface text-surface-foreground w-full rounded px-3 py-2'>
            <div className='flex items-center gap-2'>
              <Avatar>
                <AvatarImage src={getCdnUrl(user.profile?.avatarUrl as string)} />
                <AvatarFallback>{user.profile?.name?.slice(0, 2).toUpperCase()}</AvatarFallback>
              </Avatar>
              <div className='text-left'>
                <div className='text-lg font-medium'>{user.profile?.name}</div>
                <div className='text-muted-foreground text-sm'>{user.profile?.title}</div>
              </div>
            </div>
          </div>
        </motion.div>
      </DialogTrigger>
      <DialogContent className='max-w-md'>
        <DialogHeader>
          <div className='flex items-center gap-4'>
            <Avatar size='lg'>
              <AvatarImage src={getCdnUrl(user.profile?.avatarUrl as string)} />
              <AvatarFallback>{user.profile?.name?.slice(0, 2).toUpperCase()}</AvatarFallback>
            </Avatar>
            <div className='text-left'>
              <DialogTitle className='text-2xl font-medium'>{user.profile?.name}</DialogTitle>
              <div className='text-muted-foreground text-sm'>{user.profile?.title}</div>
            </div>
          </div>
        </DialogHeader>
        <div className='space-y-4'>
          {user.profile?.bio && <p className='text-sm'>{user.profile.bio}</p>}
          <div className='flex justify-end gap-2'>
            {user.profile?.website && (
              <a
                className='link text-sm'
                href={user.profile?.website}
                target='_blank'
                rel='noopener noreferrer'
              >
                Website
              </a>
            )}
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
