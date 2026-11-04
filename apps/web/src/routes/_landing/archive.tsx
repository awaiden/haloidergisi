import { Icon } from "@iconify/react";
import { useQuery } from "@tanstack/react-query";
import { createFileRoute, Link } from "@tanstack/react-router";
import { BookOpen, ChevronDown, ChevronRight, Hash, Layers } from "lucide-react";
import { useState } from "react";

import CdnImage from "@/components/cdn-image";
import { Badge } from "@/components/ui/badge";
import apiClient from "@/lib/api-client";
import { pageHead } from "@/utils/seo";

type ArchiveGenre = {
  category: string;
  works: string[];
};

type ArchiveMagazine = {
  id: string;
  title: string;
  slug: string;
  coverImage: string | null;
  postCategory: { id: string; name: string } | null;
  genres: ArchiveGenre[];
};

export const Route = createFileRoute("/_landing/archive")({
  head: () => pageHead("/archive", "Dergi Arşivi", "HALO Dergisi'nin yayımlanmış tüm sayıları."),
  component: RouteComponent,
});

function RouteComponent() {
  const { data: magazines, isLoading } = useQuery({
    queryKey: ["themes", "archive"],
    queryFn: async () => {
      const { data } = await apiClient.get<ArchiveMagazine[]>("/themes/archive");
      return data;
    },
  });

  return (
    <section className='container py-20'>
      <div className='mx-auto max-w-4xl space-y-12'>
        <div className='space-y-2'>
          <h1 className='text-4xl font-extrabold tracking-tight'>Tematik Arşiv</h1>
          <p className='text-muted-foreground text-lg'>
            Dergilerimizi ve içerdikleri konuları keşfedin
          </p>
        </div>

        {isLoading && <ArchiveSkeleton />}

        <div className='space-y-6'>
          {magazines?.map((magazine) => (
            <MagazineNode
              key={magazine.id}
              magazine={magazine}
            />
          ))}
        </div>

        {!isLoading && magazines?.length === 0 && (
          <div className='flex flex-col items-center gap-4 py-20 text-center'>
            <Icon
              icon='mdi:archive-off-outline'
              className='text-muted-foreground size-16'
            />
            <p className='text-muted-foreground text-xl'>Henüz bir içerik bulunamadı.</p>
          </div>
        )}
      </div>
    </section>
  );
}

function MagazineNode({ magazine }: { magazine: ArchiveMagazine }) {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <div className='bg-card overflow-hidden rounded-xl border shadow-sm transition-shadow duration-200 hover:shadow-md'>
      <button
        className='hover:bg-muted/30 flex w-full items-center gap-4 p-4 text-left transition-colors'
        onClick={() => setIsOpen(!isOpen)}
      >
        <div className='bg-muted relative size-20 shrink-0 overflow-hidden rounded-lg'>
          {magazine.coverImage ? (
            <CdnImage
              src={magazine.coverImage}
              alt={magazine.title}
              className='size-full object-cover'
            />
          ) : (
            <div className='flex size-full items-center justify-center'>
              <BookOpen className='text-muted-foreground/50 size-8' />
            </div>
          )}
        </div>
        <div className='min-w-0 flex-1'>
          <div className='mb-1 flex items-center gap-2'>
            {magazine.postCategory && (
              <Badge
                variant='secondary'
                className='text-[10px] uppercase'
              >
                {magazine.postCategory.name}
              </Badge>
            )}
            <span className='text-muted-foreground text-[10px]'>
              {magazine.genres.length} Kategori
            </span>
          </div>
          <h2 className='truncate text-xl font-bold'>{magazine.title}</h2>
          <Link
            to='/posts/$postId'
            params={{ postId: magazine.slug }}
            className='text-primary mt-1 flex items-center gap-1 text-xs hover:underline'
            onClick={(e) => e.stopPropagation()}
          >
            Dergiyi Oku <ChevronRight className='size-3' />
          </Link>
        </div>
        <div className='text-muted-foreground'>
          {isOpen ? <ChevronDown className='size-6' /> : <ChevronRight className='size-6' />}
        </div>
      </button>

      {isOpen && (
        <div className='bg-muted/20 animate-in fade-in slide-in-from-top-2 space-y-4 border-t p-4 duration-200'>
          {magazine.genres.map((genre, idx) => (
            <GenreNode
              key={idx}
              genre={genre}
            />
          ))}
        </div>
      )}
    </div>
  );
}

function GenreNode({ genre }: { genre: ArchiveGenre }) {
  const [isOpen, setIsOpen] = useState(true);

  return (
    <div className='bg-background overflow-hidden rounded-lg border shadow-sm'>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className='bg-muted/10 hover:bg-muted/30 flex w-full items-center justify-between p-3 transition-colors'
      >
        <div className='flex items-center gap-2'>
          <Layers className='text-primary size-4' />
          <span className='text-muted-foreground text-sm font-bold tracking-wider uppercase'>
            {genre.category}
          </span>
        </div>
        <div className='flex items-center gap-2'>
          <span className='bg-primary/10 text-primary rounded-full px-2 py-0.5 text-[10px] font-bold'>
            {genre.works.length} ESER
          </span>
          {isOpen ? <ChevronDown className='size-4' /> : <ChevronRight className='size-4' />}
        </div>
      </button>

      {isOpen && (
        <div className='animate-in fade-in slide-in-from-left-2 grid grid-cols-1 gap-2 p-3 duration-200 sm:grid-cols-2 lg:grid-cols-3'>
          {genre.works.map((work, idx) => (
            <div
              key={idx}
              className='bg-muted/40 hover:border-primary/20 hover:bg-primary/5 group flex items-center gap-2 rounded-md border border-transparent p-2 transition-all'
            >
              <Hash className='text-muted-foreground group-hover:text-primary size-3' />
              <span className='text-sm font-semibold'>{work}</span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

function ArchiveSkeleton() {
  return (
    <div className='space-y-6'>
      {Array.from({ length: 3 }).map((_, i) => (
        <div
          key={i}
          className='bg-muted h-28 w-full animate-pulse rounded-xl'
        />
      ))}
    </div>
  );
}
