import { Icon } from "@iconify/react";
import { useQuery } from "@tanstack/react-query";
import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { isAxiosError } from "axios";
import { useEffect } from "react";

import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import apiClient from "@/lib/api-client";
import { Article, SubmissionCall } from "@/types";
import { getCdnUrl } from "@/utils/cdn";

export const Route = createFileRoute("/_landing/articles/$articleId")({
  component: ArticleDetailPage,
});

function ArticleDetailPage() {
  const { articleId } = Route.useParams();
  const navigate = useNavigate();

  const {
    data: article,
    isLoading,
    isError,
    error,
  } = useQuery({
    queryKey: ["article", articleId],
    queryFn: async () => {
      const { data } = await apiClient.get<Article>(`/articles/${articleId}`);
      return data;
    },
    retry: false,
  });

  // Self-healing: If 404 occurs, check if this is actually a Call ID
  const is404 = isError && isAxiosError(error) && error.response?.status === 404;

  const { data: potentialCall } = useQuery({
    queryKey: ["check-if-call", articleId],
    queryFn: async () => {
      try {
        const { data } = await apiClient.get<SubmissionCall>(`/submission-calls/${articleId}`);
        return data;
      } catch {
        return null;
      }
    },
    enabled: is404,
  });

  useEffect(() => {
    if (potentialCall) {
      void navigate({
        to: "/articles/submit/$callId",
        params: { callId: potentialCall.id },
        replace: true,
      });
    }
  }, [potentialCall, navigate]);

  if (isLoading) {
    return (
      <div className='flex min-h-[60vh] flex-col items-center justify-center'>
        <Icon
          icon='line-md:loading-twotone-loop'
          className='text-primary mb-4 h-12 w-12'
        />
        <p className='text-muted-foreground animate-pulse font-medium'>Yazı yükleniyor...</p>
      </div>
    );
  }

  if (isError && !potentialCall) {
    return (
      <div className='container mx-auto px-4 py-20 text-center'>
        <Icon
          icon='solar:danger-bold-duotone'
          className='text-destructive mx-auto mb-6 h-20 w-20'
        />
        <h2 className='mb-2 text-3xl font-bold'>Yazı Bulunamadı</h2>
        <p className='text-muted-foreground mb-8 text-lg'>
          Görüntülemek istediğiniz yazı mevcut değil veya erişim yetkiniz yok.
        </p>
        <Button
          size='lg'
          asChild
        >
          <Link to='/articles/my'>Yazılarıma Dön</Link>
        </Button>
      </div>
    );
  }

  if (!article) return null;

  return (
    <div className='container mx-auto max-w-4xl px-4 py-12'>
      <div className='mb-8 space-y-4'>
        <Button
          variant='ghost'
          size='sm'
          asChild
          className='text-muted-foreground hover:text-foreground -ml-2'
        >
          <Link to='/articles/my'>
            <Icon
              icon='solar:arrow-left-linear'
              className='mr-2 h-4 w-4'
            />
            Geri Dön
          </Link>
        </Button>
        <div className='space-y-2'>
          <h1 className='text-4xl font-extrabold tracking-tight lg:text-5xl'>{article.title}</h1>
          <div className='text-muted-foreground flex items-center gap-4'>
            <div className='flex items-center gap-1.5 text-sm'>
              <Icon icon='solar:calendar-date-bold-duotone' />
              {new Date(article.createdAt).toLocaleDateString("tr-TR", {
                day: "numeric",
                month: "long",
                year: "numeric",
              })}
            </div>
            <Separator
              orientation='vertical'
              className='h-4'
            />
            <div className='flex items-center gap-1.5 text-sm'>
              <Icon icon='solar:user-bold-duotone' />
              {article.author?.profile?.name || "Yazar"}
            </div>
          </div>
        </div>
      </div>

      <Card className='mb-8 border-2 shadow-sm'>
        <CardHeader>
          <div className='flex items-center justify-between'>
            <CardTitle>Yazı İçeriği</CardTitle>
            <div
              className={`rounded-full px-3 py-1 text-xs font-bold uppercase ${
                article.status === "APPROVED"
                  ? "bg-green-100 text-green-700"
                  : article.status === "REJECTED"
                    ? "bg-red-100 text-red-700"
                    : "bg-blue-100 text-blue-700"
              }`}
            >
              {article.status}
            </div>
          </div>
        </CardHeader>
        <CardContent className='space-y-6'>
          {article.fileUrl && (
            <div className='bg-primary/5 border-primary/20 rounded-xl border p-5'>
              <div className='flex flex-col justify-between gap-4 sm:flex-row sm:items-center'>
                <div className='flex items-center gap-3 overflow-hidden'>
                  <div className='bg-primary/10 text-primary flex h-10 w-10 shrink-0 items-center justify-center rounded-lg'>
                    <Icon
                      icon='solar:document-bold-duotone'
                      className='h-6 w-6'
                    />
                  </div>
                  <div className='min-w-0'>
                    <p className='text-muted-foreground text-xs font-semibold tracking-wider uppercase'>
                      Gönderilen Dosya
                    </p>
                    <p className='text-foreground truncate text-sm font-medium'>
                      {article.fileUrl}
                    </p>
                  </div>
                </div>
                <Button
                  asChild
                  variant='default'
                  size='sm'
                  className='shrink-0 shadow-sm'
                >
                  <a
                    href={getCdnUrl(article.fileUrl)}
                    target='_blank'
                    rel='noopener noreferrer'
                  >
                    <Icon
                      icon='solar:file-download-bold-duotone'
                      className='mr-1.5 h-4 w-4'
                    />
                    Görüntüle / İndir
                  </a>
                </Button>
              </div>
            </div>
          )}

          {article.content && (
            <div className='space-y-2'>
              <h3 className='text-muted-foreground text-xs font-semibold tracking-wider uppercase'>
                Ek Notlar / Özet
              </h3>
              <div className='prose prose-base dark:prose-invert text-muted-foreground max-w-none leading-relaxed whitespace-pre-wrap'>
                {article.content}
              </div>
            </div>
          )}
        </CardContent>
      </Card>

      {article.adminNote && (
        <Alert className='bg-primary/5 border-primary/20'>
          <Icon
            icon='solar:pen-new-square-bold-duotone'
            className='text-primary h-5 w-5'
          />
          <AlertTitle className='text-primary font-bold'>Editör Notu</AlertTitle>
          <AlertDescription className='text-foreground/80 mt-1 italic'>
            "{article.adminNote}"
          </AlertDescription>
        </Alert>
      )}
    </div>
  );
}
