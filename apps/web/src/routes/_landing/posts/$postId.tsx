import { zodResolver } from "@hookform/resolvers/zod";
import { Icon } from "@iconify/react";
import { useQuery } from "@tanstack/react-query";
import { createFileRoute, Link } from "@tanstack/react-router";
import { useState } from "react";
import { useForm } from "react-hook-form";
import { toast } from "sonner";

import { Breadcrumb, BreadcrumbItem } from "@/components/breadcrumbs";
import CdnImage from "@/components/cdn-image";
import Markdown from "@/components/markdown";
import { PostCard, PostCardSkeleton } from "@/components/post-card";
import { Turnstile } from "@/components/turnstile";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import apiClient from "@/lib/api-client";
import { feedbackSchema, FeedbackSchema } from "@/schemas/message";
import { Post } from "@/types";
import { QueryRes } from "@/types";
import { getCdnUrl } from "@/utils/cdn";
import { generateCanonicalUrl, generateMetaTags, generateStructuredData } from "@/utils/seo";

export const Route = createFileRoute("/_landing/posts/$postId")({
  component: RouteComponent,
  loader: async ({ params }) => {
    const { data: post } = await apiClient.get<Post>(`/posts/${params.postId}`);

    return { post };
  },
  head: ({ loaderData }) => {
    const post = loaderData?.post;
    if (!post) return { meta: [] };

    const canonicalUrl = generateCanonicalUrl(`/posts/${post.slug}`);
    const coverImageUrl = post.coverImage ? getCdnUrl(post.coverImage) : undefined;

    const meta = generateMetaTags({
      title: post.title,
      description:
        post.content?.replace(/[#*`]/g, "").slice(0, 160) || `${post.title} - HALO Dergisi`,
      keywords: [post.category?.name || "Dergi", "HALO Dergisi", "edebiyat", "sanat"],
      canonical: canonicalUrl,
      type: "article",
      image: coverImageUrl,
      imageAlt: post.title,
      publishedTime: post.createdAt ? new Date(post.createdAt).toISOString() : undefined,
      modifiedTime: post.updatedAt ? new Date(post.updatedAt).toISOString() : undefined,
      section: post.category?.name,
    });

    const structuredData = generateStructuredData("Article", {
      headline: post.title,
      description: post.content?.slice(0, 160) || post.title,
      image: coverImageUrl,
      datePublished: post.createdAt,
      dateModified: post.updatedAt || post.createdAt,
      author: "HALO Dergisi Editörleri",
      authorType: "Organization",
      url: canonicalUrl,
      publisherLogo: `${typeof window !== "undefined" ? window.location.origin : ""}/logo.png`,
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
  const { post } = Route.useLoaderData();

  return (
    <div className='container py-20'>
      <div className='space-y-10'>
        <Breadcrumb>
          <BreadcrumbItem>
            <Link
              to='/'
              className='link'
            >
              Ana Sayfa
            </Link>
          </BreadcrumbItem>
          <BreadcrumbItem>
            <Link
              to='/posts'
              className='link'
              search={{}}
            >
              Tüm Dergiler
            </Link>
          </BreadcrumbItem>
          <BreadcrumbItem>{post.title}</BreadcrumbItem>
        </Breadcrumb>

        <div className='grid grid-cols-12 gap-4 md:gap-8'>
          <div className='col-span-12 md:col-span-3'>
            <div className='space-y-4'>
              <CdnImage
                src={post.coverImage!}
                alt={post.title}
              />

              <div className='flex justify-end'>
                <FeedbackForm />
              </div>

              <div className='hidden md:block'>
                <Button
                  asChild
                  className='w-full'
                >
                  <Link
                    to={getCdnUrl(post.attachment!)}
                    target='_blank'
                    rel='noopener noreferrer'
                  >
                    <Icon icon='mdi:download' />
                    Dergiyi İndir
                  </Link>
                </Button>
              </div>
            </div>
          </div>
          <div className='col-span-12 md:col-span-6'>
            <div className='space-y-2'>
              <h1 className='text-3xl font-bold'>{post.title}</h1>
              <Markdown className='text-sm'>
                {post.content ?? "lorem ipsum dolor sit amet"}
              </Markdown>
            </div>
          </div>
          <aside className='col-span-12 md:col-span-3'>
            <h4 className='mb-4 text-xl font-semibold'>Dergi Bilgileri</h4>
            <ul className='space-y-2'>
              <li className='flex items-center justify-between'>
                <strong>Kategori</strong>
                <span>{post.category?.name}</span>
              </li>
              <li className='flex items-center justify-between'>
                <strong>Yayın Tarihi</strong>
                <span>
                  {new Date(post.createdAt!).toLocaleDateString("tr-TR", {
                    year: "numeric",
                    month: "long",
                    day: "numeric",
                  })}
                </span>
              </li>
              <li className='flex items-center justify-between'>
                <strong>PDF</strong>
                <a
                  href={getCdnUrl(post.attachment!)}
                  target='_blank'
                  rel='noopener noreferrer'
                  className='link'
                >
                  İndir
                </a>
              </li>
              <li className='mt-4 md:hidden'>
                <Button
                  asChild
                  className='w-full'
                >
                  <Link
                    to={getCdnUrl(post.attachment!)}
                    target='_blank'
                    rel='noopener noreferrer'
                  >
                    <Icon icon='mdi:download' />
                    Dergiyi İndir
                  </Link>
                </Button>
              </li>
            </ul>
          </aside>
        </div>
        <br />
        <FeaturedPosts />
      </div>
    </div>
  );
}

function FeaturedPosts() {
  const { post } = Route.useLoaderData();

  const { data: posts } = useQuery({
    queryKey: ["featured-posts", post.id],
    queryFn: async () => {
      const { data } = await apiClient.get<QueryRes<Post>>("/posts", {
        params: { limit: 3, filter: JSON.stringify({ id: { not: post.id } }) },
      });

      return data;
    },
  });

  return (
    <div className='space-y-4'>
      <div className='flex flex-wrap justify-between gap-2'>
        <div className='space-y-1'>
          <h2 className='text-2xl font-bold'>Öne Çıkan Dergiler</h2>
          <p className='text-muted-foreground'>Son eklenen dergilere göz atın</p>
        </div>
        <div className='flex items-end justify-end'></div>
      </div>
      <div className='grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3'>
        {posts?.items.map((post) => (
          <PostCard
            key={post.id}
            post={post}
          />
        ))}
        {!posts && [...Array(3)].map((_, index) => <PostCardSkeleton key={index} />)}
      </div>
    </div>
  );
}

function FeedbackForm() {
  const { post } = Route.useLoaderData();
  const [trunstileToken, setTurnstileToken] = useState<string | null>(null);
  const [isOpen, setIsOpen] = useState(false);

  const form = useForm<FeedbackSchema>({
    resolver: zodResolver(feedbackSchema),
  });

  const onSubmit = async (data: FeedbackSchema) => {
    if (!trunstileToken) {
      toast.error("Lütfen CAPTCHA doğrulamasını tamamlayın.");
      return;
    }

    try {
      await apiClient.post("/messages", {
        "cf-turnstile-response": trunstileToken,
        subject: `Dergi Geri Bildirimi: ${post.title}`,
        name: data.name ?? "Anonim",
        email: data.email ?? "anon@example.com",
        content: data.content,
      });
      toast.success("Geri bildiriminiz için teşekkürler!");
      form.reset();
      setIsOpen(false);
    } catch (error) {
      const resolved = apiClient.resolveApiError(error);
      toast.error(resolved.message, {
        description: resolved.error,
      });
    }
  };

  return (
    <Dialog
      open={isOpen}
      onOpenChange={setIsOpen}
    >
      <DialogTrigger asChild>
        <Button variant='ghost'>
          <Icon icon='mdi:message-text-outline' />
          Geri Bildirim Gönder
        </Button>
      </DialogTrigger>
      <DialogContent className='max-h-[90vh] overflow-y-auto'>
        <DialogHeader>
          <DialogTitle>Geri Bildirim Gönder</DialogTitle>
          <DialogDescription>
            Dergi ile ilgili geri bildirimlerinizi bizimle paylaşın.
          </DialogDescription>
        </DialogHeader>

        <Form {...form}>
          <form
            onSubmit={form.handleSubmit(onSubmit)}
            className='space-y-4'
          >
            <FormField
              control={form.control}
              name='email'
              render={({ field }) => (
                <FormItem>
                  <FormLabel>E-posta (isteğe bağlı)</FormLabel>
                  <FormControl>
                    <Input
                      type='email'
                      {...field}
                    />
                  </FormControl>
                  <FormDescription>
                    Size geri dönüş yapabilmemiz için geçerli bir e-posta adresi bırakabilirsiniz.
                  </FormDescription>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control}
              name='name'
              render={({ field }) => (
                <FormItem>
                  <FormLabel>İsim (isteğe bağlı)</FormLabel>
                  <FormControl>
                    <Input {...field} />
                  </FormControl>
                  <FormDescription>İsterseniz isminizi de bırakabilirsiniz.</FormDescription>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control}
              name='content'
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Geri Bildirim</FormLabel>
                  <FormControl>
                    <Textarea
                      rows={6}
                      {...field}
                    />
                  </FormControl>
                  <FormDescription>
                    Dergi ile ilgili düşüncelerinizi, önerilerinizi veya eleştirilerinizi
                    paylaşabilirsiniz.
                  </FormDescription>
                  <FormMessage />
                </FormItem>
              )}
            />

            <Turnstile
              onVerify={setTurnstileToken}
              onExpire={() => setTurnstileToken(null)}
            />

            <Button
              className={"w-full"}
              type='submit'
            >
              Gönder
            </Button>
          </form>
        </Form>
      </DialogContent>
    </Dialog>
  );
}
