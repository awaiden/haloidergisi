import type { Post } from "@repo/db";

import { Icon } from "@iconify/react";
import { useQuery } from "@tanstack/react-query";
import { createFileRoute, Link } from "@tanstack/react-router";
import { motion } from "motion/react";

import { PostCard, PostCardSkeleton } from "@/components/post-card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { socialLinks } from "@/constants";
import apiClient from "@/lib/api-client";
import { SITE_URL } from "@/lib/env";
import { useThemeConfig } from "@/queries/use-theme-config";
import { QueryRes } from "@/types";
import { generateCanonicalUrl, generateMetaTags, generateStructuredData } from "@/utils/seo";

export const Route = createFileRoute("/_landing/")({
  component: RouteComponent,
  head: () => {
    const canonicalUrl = generateCanonicalUrl("/");
    const meta = generateMetaTags({
      title: "Ana Sayfa - Aylık Fikir, Sanat ve Edebiyat Dergisi",
      description:
        "HALO Dergisi, öğrenciler tarafından hazırlanan aylık fikir, sanat ve edebiyat dergisidir. Dergilerimize göz atın, makalelerimizi okuyun ve topluluğumuza katılın.",
      keywords: [
        "HALO Dergisi",
        "edebiyat dergisi",
        "sanat dergisi",
        "öğrenci dergisi",
        "fikir platformu",
        "dergi arşivi",
      ],
      canonical: canonicalUrl,
      type: "website",
      image: `${SITE_URL}/logo.png`,
      imageAlt: "HALO Dergisi Logo",
    });

    const structuredData = generateStructuredData("WebSite", {
      name: "HALO Dergisi",
      url: canonicalUrl,
      description:
        "Aylık fikir, sanat ve edebiyat dergisi. Öğrenciler tarafından, öğrenciler için hazırlanan özgün içerikler.",
    });

    return {
      meta,
      links: [{ rel: "canonical", href: canonicalUrl }],
      scripts: structuredData
        ? [
            {
              type: "application/ld+json",
              children: JSON.stringify(structuredData),
            },
          ]
        : [],
    };
  },
});

function RouteComponent() {
  return (
    <div>
      <div className='flex h-full flex-col gap-20'>
        <HeroSection />
        <PostsSection />
      </div>
    </div>
  );
}

function HeroSection() {
  const { data: theme } = useThemeConfig();
  const heroSrc =
    theme?.preset === "halloween" ? "/halloween-hero.svg" : "/undraw_book-lover_m9n3.svg";

  return (
    <section className='container py-20'>
      <div className='grid grid-cols-1 gap-16 md:grid-cols-2'>
        <div className='space-y-4'>
          <Badge size='sm'>
            <Icon icon='mdi:sparkles' />
            <span className='font-bold'>HALO Dergisi</span>
          </Badge>

          <h1 className='text-4xl font-bold md:text-5xl'>Aylık Fikir, Sanat ve Edebiyat Dergisi</h1>
          <p className='text-muted-foreground text-lg'>
            Bölümümüze ve öğrencilerine katkı sağlamak amacıyla, diğer fakülteler dahil olmak üzere;
            ortaya bir fikir- edebiyat dergisi sunmak için bir araya gelmiş bir grup öğrenciyiz.
          </p>
          <div className='flex flex-wrap items-center gap-4'>
            <Button asChild>
              <Link to='/posts'>
                <Icon icon='mdi:post-outline' />
                Dergilere Göz At
              </Link>
            </Button>
            <Button
              asChild
              variant='outline'
            >
              <Link to='/about'>
                <Icon icon='mdi:information-outline' />
                Hakkımızda
              </Link>
            </Button>
          </div>
          <br />
          <div className='flex flex-wrap gap-4'>
            {Object.values(socialLinks).map((link) => (
              <motion.div
                key={link.url}
                whileHover={{ scale: 1.1 }}
                transition={{ type: "spring", stiffness: 300 }}
              >
                <a
                  href={link.url}
                  target='_blank'
                  rel='noopener noreferrer'
                  className='link'
                >
                  <Icon
                    icon={link.icon}
                    className='size-6'
                  />
                  <span>{link.label}</span>
                </a>
              </motion.div>
            ))}
          </div>
        </div>
        <div className='hidden h-full items-center justify-center md:flex'>
          <img
            className='h-96 w-full object-contain'
            src={heroSrc}
            alt='Hero Banner'
          />
        </div>
      </div>
    </section>
  );
}

function PostsSection() {
  const { data: posts } = useQuery({
    queryKey: ["posts", "landing"],
    queryFn: async () => {
      const { data } = await apiClient.get<QueryRes<Post>>("/posts", {
        params: {
          status: "PUBLISHED",
          limit: 6,
        },
      });
      return data;
    },
  });

  return (
    <section className='container py-20'>
      <div className='space-y-4'>
        <div className='flex flex-wrap justify-between gap-4'>
          <div>
            <h2 className='text-xl font-bold'>Öne Çıkan Dergiler</h2>
            <p className='text-muted-foreground'>Son eklenen dergilere göz atın</p>
          </div>
          <div className='flex w-full items-end justify-end'>
            <Link
              to='/posts'
              className='link'
            >
              Tüm Dergiler
              <Icon icon='mdi:chevron-right' />
            </Link>
          </div>
        </div>
        <div className='grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3'>
          {posts?.items.map((post) => (
            <PostCard
              key={post.id}
              post={post}
            />
          ))}
          {!posts && Array.from({ length: 6 }).map((_, index) => <PostCardSkeleton key={index} />)}
        </div>
      </div>
    </section>
  );
}
