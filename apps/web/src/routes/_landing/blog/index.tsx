import { Icon } from "@iconify/react";
import { useQuery } from "@tanstack/react-query";
import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useMemo } from "react";
import * as z from "zod";

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardFooter } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import apiClient from "@/lib/api-client";
import { News } from "@/types";
import { generateCanonicalUrl, generateMetaTags } from "@/utils/seo";

const blogSearchSchema = z.object({
  q: z.string().optional().catch(""),
  view: z.enum(["grid", "list"]).optional().catch("grid"),
});

export const Route = createFileRoute("/_landing/blog/")({
  validateSearch: (search) => blogSearchSchema.parse(search),
  component: BlogLandingPage,
  head: () => {
    const canonicalUrl = generateCanonicalUrl("/blog");
    const meta = generateMetaTags({
      title: "Blog & Duyurular",
      description:
        "HALO Dergisi'nden en son haberler, güncellemeler ve topluluk duyuruları. Dergimizle ilgili gelişmeleri takip edin.",
      keywords: ["HALO blog", "dergi duyuruları", "gündem", "haberler", "topluluk"],
      canonical: canonicalUrl,
      type: "website",
    });

    return {
      meta,
      links: [{ rel: "canonical", href: canonicalUrl }],
    };
  },
});

function BlogLandingPage() {
  const { q: searchQuery, view: viewMode } = Route.useSearch();
  const navigate = useNavigate({ from: Route.fullPath });

  const { data: news, isLoading } = useQuery({
    queryKey: ["news"],
    queryFn: async () => {
      const { data } = await apiClient.get<News[]>("/news");
      return data;
    },
  });

  const setSearchQuery = (q: string) => {
    void navigate({ search: (prev) => ({ ...prev, q }) });
  };

  const setViewMode = (view: "grid" | "list") => {
    void navigate({ search: (prev) => ({ ...prev, view }) });
  };

  const filteredNews = useMemo(() => {
    if (!news) return [];
    const search = searchQuery || "";

    return news.filter((item) => {
      return (
        item.title.toLowerCase().includes(search.toLowerCase()) ||
        item.content.toLowerCase().includes(search.toLowerCase())
      );
    });
  }, [news, searchQuery]);

  return (
    <div className='container mx-auto max-w-6xl px-4 py-12'>
      <div className='mb-12 flex flex-col items-start justify-between gap-6 md:flex-row md:items-end'>
        <div className='space-y-4'>
          <Badge
            variant='outline'
            className='px-3 py-1'
          >
            <Icon
              icon='solar:globus-bold-duotone'
              className='text-primary mr-2'
            />
            HALO Gündem
          </Badge>
          <h1 className='text-4xl font-extrabold tracking-tight text-balance md:text-5xl'>
            Blog & Duyurular
          </h1>
          <p className='text-muted-foreground max-xl text-xl'>
            HALO Dergisi'nden en son haberler, güncellemeler ve topluluk duyuruları.
          </p>
        </div>

        <div className='w-full space-y-3 md:w-80'>
          <div className='relative'>
            <Icon
              icon='solar:magnifer-linear'
              className='text-muted-foreground absolute top-1/2 left-3 -translate-y-1/2'
            />
            <Input
              placeholder='Haberlerde ara...'
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className='focus-visible:ring-primary h-11 rounded-xl border-2 pl-10'
            />
          </div>
          <div className='flex items-center gap-2'>
            <Button
              variant={viewMode === "grid" ? "default" : "outline"}
              size='icon-sm'
              onClick={() => setViewMode("grid")}
              className='rounded-lg'
            >
              <Icon icon='solar:widget-bold-duotone' />
            </Button>
            <Button
              variant={viewMode === "list" ? "default" : "outline"}
              size='icon-sm'
              onClick={() => setViewMode("list")}
              className='rounded-lg'
            >
              <Icon icon='solar:list-bold-duotone' />
            </Button>
          </div>
        </div>
      </div>

      {isLoading ? (
        <div
          className={
            viewMode === "grid" ? "grid gap-8 md:grid-cols-2 lg:grid-cols-3" : "flex flex-col gap-6"
          }
        >
          {[1, 2, 3, 4, 5, 6].map((i) => (
            <div
              key={i}
              className={`bg-muted animate-pulse rounded-2xl ${viewMode === "grid" ? "h-72" : "h-32"}`}
            />
          ))}
        </div>
      ) : (
        <div
          className={
            viewMode === "grid" ? "grid gap-8 md:grid-cols-2 lg:grid-cols-3" : "flex flex-col gap-6"
          }
        >
          {filteredNews.map((item) => (
            <Link
              key={item.id}
              to='/blog/$slug'
              params={{ slug: item.slug }}
              className='group'
            >
              <Card
                className={`group-hover:border-primary group-hover:shadow-primary/5 flex h-full overflow-hidden border-2 transition-all duration-300 group-hover:shadow-xl ${viewMode === "list" ? "h-auto flex-row" : "flex-col"}`}
              >
                <CardHeader className={viewMode === "list" ? "w-2/3" : ""}>
                  <div className='mb-3 flex items-center justify-between'>
                    <span className='text-muted-foreground flex items-center gap-1.5 text-xs font-medium'>
                      <Icon icon='solar:calendar-linear' />
                      {item.publishedAt
                        ? new Date(item.publishedAt).toLocaleDateString("tr-TR")
                        : "Taslak"}
                    </span>
                  </div>
                  <CardTitle
                    className={`${viewMode === "list" ? "text-xl" : "text-2xl"} group-hover:text-primary line-clamp-2 leading-tight transition-colors`}
                  >
                    {item.title}
                  </CardTitle>
                </CardHeader>
                <div
                  className={`flex flex-1 flex-col ${viewMode === "list" ? "w-1/3 border-l" : ""}`}
                >
                  <CardContent className='flex-1'>
                    <p className='text-muted-foreground line-clamp-3 text-sm leading-relaxed'>
                      {item.content.replace(/[#*`]/g, "").slice(0, 160)}...
                    </p>
                    <div className='mt-4 flex flex-wrap gap-2'>
                      {item.keywords
                        ?.split(",")
                        .slice(0, 3)
                        .map((k) => (
                          <span
                            key={k}
                            className='text-primary/60 bg-primary/5 rounded px-2 py-0.5 text-[10px] font-bold tracking-tight uppercase'
                          >
                            #{k.trim()}
                          </span>
                        ))}
                    </div>
                  </CardContent>
                  <CardFooter className='bg-muted/20 mt-auto border-t pt-0'>
                    <div className='text-primary flex items-center py-3 text-xs font-bold transition-transform group-hover:translate-x-1'>
                      DEVAMINI OKU
                      <Icon
                        icon='solar:arrow-right-linear'
                        className='ml-2'
                      />
                    </div>
                  </CardFooter>
                </div>
              </Card>
            </Link>
          ))}
        </div>
      )}

      {!isLoading && filteredNews.length === 0 && (
        <div className='bg-muted/20 rounded-3xl border-2 border-dashed py-24 text-center'>
          <Icon
            icon='solar:map-arrow-square-bold-duotone'
            className='text-muted-foreground/50 mx-auto mb-6 h-20 w-20'
          />
          <h3 className='text-2xl font-bold'>Sonuç Bulunamadı</h3>
          <p className='text-muted-foreground mt-2 text-lg'>
            Arama kriterlerinize uygun bir haber mevcut değil.
          </p>
          <Button
            variant='link'
            onClick={() => {
              void navigate({ search: {} });
            }}
            className='text-primary mt-4 text-lg'
          >
            Aramayı Temizle
          </Button>
        </div>
      )}
    </div>
  );
}
