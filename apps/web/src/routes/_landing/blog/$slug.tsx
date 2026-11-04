import { Icon } from "@iconify/react";
import { useQuery } from "@tanstack/react-query";
import { createFileRoute, Link } from "@tanstack/react-router";

import Markdown from "@/components/markdown";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import apiClient from "@/lib/api-client";
import { SITE_URL } from "@/lib/env";
import { News } from "@/types";
import { generateCanonicalUrl, generateMetaTags, generateStructuredData } from "@/utils/seo";

export const Route = createFileRoute("/_landing/blog/$slug")({
  component: BlogDetailPage,
  loader: async ({ params }) => {
    const { data } = await apiClient.get<News>(`/news/${params.slug}`);
    return { news: data };
  },
  head: ({ loaderData }) => {
    const news = loaderData?.news;
    if (!news) return { meta: [] };

    const canonicalUrl = generateCanonicalUrl(`/blog/${news.slug}`);
    const meta = generateMetaTags({
      title: news.title,
      description: news.content.replace(/[#*`]/g, "").slice(0, 160),
      keywords: news.keywords?.split(",").map((k) => k.trim()),
      author: news.author?.profile?.name || "HALO Editör",
      canonical: canonicalUrl,
      type: "article",
      publishedTime: news.publishedAt ? new Date(news.publishedAt).toISOString() : undefined,
      modifiedTime: news.updatedAt ? new Date(news.updatedAt).toISOString() : undefined,
      section: "Blog",
      tags: news.keywords?.split(",").map((k) => k.trim()),
    });

    const structuredData = generateStructuredData("Article", {
      headline: news.title,
      description: news.content.replace(/[#*`]/g, "").slice(0, 160),
      datePublished: news.publishedAt,
      dateModified: news.updatedAt || news.publishedAt,
      author: news.author?.profile?.name || "HALO Editör",
      authorType: "Person",
      url: canonicalUrl,
      publisherLogo: `${SITE_URL}/logo.png`,
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

function BlogDetailPage() {
  const { news: item } = Route.useLoaderData();
  const { slug } = Route.useParams();

  const { isLoading, isError } = useQuery({
    queryKey: ["news", slug],
    queryFn: async () => {
      const { data } = await apiClient.get<News>(`/news/${slug}`);
      return data;
    },
    initialData: item,
  });

  if (isLoading) {
    return (
      <div className='flex min-h-[60vh] flex-col items-center justify-center'>
        <Icon
          icon='line-md:loading-twotone-loop'
          className='text-primary mb-4 h-12 w-12'
        />
        <p className='text-muted-foreground animate-pulse font-medium'>İçerik yükleniyor...</p>
      </div>
    );
  }

  if (isError || !item) {
    return (
      <div className='container mx-auto px-4 py-20 text-center'>
        <Icon
          icon='solar:danger-bold-duotone'
          className='text-destructive mx-auto mb-6 h-20 w-20'
        />
        <h2 className='mb-2 text-3xl font-bold'>Paylaşım Bulunamadı</h2>
        <p className='text-muted-foreground mb-8 text-lg'>
          Aradığınız haber yayından kaldırılmış olabilir.
        </p>
        <Button
          size='lg'
          asChild
        >
          <Link to='/blog'>Blog'a Geri Dön</Link>
        </Button>
      </div>
    );
  }

  return (
    <article className='container mx-auto max-w-4xl px-4 py-12'>
      <div className='mb-10 space-y-6 text-center'>
        <Button
          variant='ghost'
          size='sm'
          asChild
          className='text-muted-foreground hover:text-foreground'
        >
          <Link to='/blog'>
            <Icon
              icon='solar:arrow-left-linear'
              className='mr-2 h-4 w-4'
            />
            Tüm Haberler
          </Link>
        </Button>

        <div className='space-y-4'>
          <div className='flex flex-wrap justify-center gap-2'>
            {item.keywords?.split(",").map((k) => (
              <Badge
                key={k}
                variant='secondary'
                className='px-3 text-[10px] font-bold tracking-widest uppercase'
              >
                {k.trim()}
              </Badge>
            ))}
          </div>
          <h1 className='text-4xl leading-tight font-extrabold tracking-tight md:text-6xl'>
            {item.title}
          </h1>
          <div className='text-muted-foreground flex items-center justify-center gap-4 font-medium'>
            <span className='flex items-center gap-1.5 text-sm'>
              <Icon
                icon='solar:calendar-date-bold-duotone'
                className='text-primary'
              />
              {item.publishedAt
                ? new Date(item.publishedAt).toLocaleDateString("tr-TR", {
                    day: "numeric",
                    month: "long",
                    year: "numeric",
                  })
                : "Taslak"}
            </span>
            <Separator
              orientation='vertical'
              className='h-4'
            />
            <span className='flex items-center gap-1.5 text-sm'>
              <Icon
                icon='solar:user-bold-duotone'
                className='text-primary'
              />
              {item.author?.profile?.name || "HALO Editör"}
            </span>
          </div>
        </div>
      </div>

      <Separator className='mb-12' />

      <div className='prose prose-lg dark:prose-invert prose-headings:font-bold prose-p:leading-relaxed prose-pre:bg-muted prose-pre:border prose-img:rounded-2xl max-w-none'>
        <Markdown>{item.content}</Markdown>
      </div>

      <Separator className='my-12' />

      <div className='bg-muted/40 space-y-4 rounded-3xl border-2 border-dashed p-8 text-center'>
        <Icon
          icon='solar:star-bold-duotone'
          className='text-primary mx-auto h-12 w-12'
        />
        <h3 className='text-xl font-bold'>HALO Dergisi'ni Takip Edin</h3>
        <p className='text-muted-foreground mx-auto max-w-md'>
          En son güncellemelerden ve dergi sayılarından haberdar olmak için topluluğumuza katılın.
        </p>
        <Button
          variant='outline'
          asChild
          className='rounded-full px-8'
        >
          <Link to='/posts'>Dergilere Göz At</Link>
        </Button>
      </div>
    </article>
  );
}
