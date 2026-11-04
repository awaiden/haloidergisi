import { Icon } from "@iconify/react";
import { Category } from "@repo/db";
import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { z } from "zod";

import Pagination from "@/components/pagination";
import { PostCard } from "@/components/post-card";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import useDebounce from "@/hooks/use-debounce";
import apiClient from "@/lib/api-client";
import { Post, QueryRes } from "@/types";
import { pageHead } from "@/utils/seo";

const searchSchema = z.object({
  page: z.number().optional(),
  limit: z.number().optional(),
  search: z.string().optional(),
  categoryId: z.string().optional(),
  sort: z.string().optional(),
});

type Search = z.infer<typeof searchSchema>;

export const Route = createFileRoute("/_landing/posts/")({
  head: () =>
    pageHead("/posts", "Dergiler", "HALO Dergisi'nin tüm sayıları: dergileri çevrimiçi okuyun."),
  component: RouteComponent,
  validateSearch: (search): Search => searchSchema.parse(search),
  loaderDeps: ({ search: { page, limit, search, categoryId, sort } }: { search: Search }) => ({
    page,
    limit,
    search,
    categoryId,
    sort,
  }),
  loader: async ({ deps }) => {
    const [postsRes, categoriesRes] = await Promise.all([
      apiClient.get<QueryRes<Post>>("/posts", {
        params: {
          status: "PUBLISHED",
          fields: JSON.stringify({ category: true }),
          ...deps,
        },
      }),
      apiClient.get<QueryRes<Category>>("/categories", {
        params: { limit: -1 },
      }),
    ]);

    return { posts: postsRes.data, categories: categoriesRes.data };
  },
});

function RouteComponent() {
  const { posts, categories } = Route.useLoaderData();
  const search = Route.useSearch();
  const navigate = useNavigate({ from: Route.fullPath });

  const [searchInput, setSearchInput] = useState(search.search ?? "");
  const debouncedSearch = useDebounce(searchInput, 400);

  useEffect(() => {
    void navigate({
      search: (old: Search) => ({
        ...old,
        search: debouncedSearch || undefined,
        page: undefined,
      }),
      replace: true,
    });
  }, [debouncedSearch, navigate]);

  const handleCategoryChange = (value: string) => {
    void navigate({
      search: (old: Search) => ({
        ...old,
        categoryId: value === "__none__" ? undefined : value,
        page: undefined,
      }),
    });
  };

  const handleSortChange = (value: string) => {
    void navigate({
      search: (old: Search) => ({
        ...old,
        sort: value === "__none__" ? undefined : value,
        page: undefined,
      }),
    });
  };

  return (
    <div className='container py-20'>
      <div className='space-y-6'>
        <div className='space-y-2'>
          <h2 className='text-2xl font-bold'>Tüm Yazılar</h2>
          <p className='text-muted-foreground text-sm'>
            Dergiler, edebiyat dünyasındaki en önemli yayın organlarından biridir. Bu sayfada, HALO
            tarafından paylaşılan dergilere erişebilirsiniz.
          </p>
        </div>

        <div className='flex flex-wrap gap-3'>
          <div className='relative min-w-56 flex-1'>
            <Icon
              icon='mdi:magnify'
              className='text-muted-foreground absolute top-1/2 left-2.5 -translate-y-1/2'
            />
            <Input
              className='pl-8'
              placeholder='Yazı ara...'
              value={searchInput}
              onChange={(e) => setSearchInput(e.target.value)}
            />
          </div>

          <Select
            value={search.categoryId ?? "__none__"}
            onValueChange={handleCategoryChange}
          >
            <SelectTrigger className='w-44'>
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value='__none__'>Tüm kategoriler</SelectItem>
              {categories.items.map((cat) => (
                <SelectItem
                  key={cat.id}
                  value={cat.id}
                >
                  {cat.name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>

          <Select
            value={search.sort ?? "__none__"}
            onValueChange={handleSortChange}
          >
            <SelectTrigger className='w-44'>
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value='__none__'>En yeni</SelectItem>
              <SelectItem value='createdAt:asc'>En eski</SelectItem>
            </SelectContent>
          </Select>
        </div>

        {posts.items.length === 0 ? (
          <div className='text-muted-foreground py-16 text-center'>
            <Icon
              icon='mdi:file-search-outline'
              className='mx-auto mb-2 size-10'
            />
            <p>Sonuç bulunamadı.</p>
          </div>
        ) : (
          <div className='grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3'>
            {posts.items.map((post) => (
              <PostCard
                key={post.id}
                post={post}
              />
            ))}
          </div>
        )}

        <Pagination
          currentPage={posts.meta.skip / posts.meta.take + 1}
          totalPages={Math.ceil(posts.meta.total / posts.meta.take)}
        />
      </div>
    </div>
  );
}
