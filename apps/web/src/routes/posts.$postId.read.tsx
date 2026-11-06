import { ClientOnly, createFileRoute, Link } from "@tanstack/react-router";
import { ArrowLeft, ChevronLeft, ChevronRight } from "lucide-react";
import workerSrc from "pdfjs-dist/build/pdf.worker.min.mjs?url";
import { useCallback, useEffect, useState } from "react";
import { Document, Page, pdfjs } from "react-pdf";

import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import apiClient from "@/lib/api-client";
import { downloadIssue, getCachedIssue, removeIssue } from "@/lib/issue-cache";
import { getLastPage, saveLastPage } from "@/lib/reading-progress";
import { Post } from "@/types";
import { getCdnUrl } from "@/utils/cdn";

pdfjs.GlobalWorkerOptions.workerSrc = workerSrc;

export const Route = createFileRoute("/posts/$postId/read")({
  loader: async ({ params }) => {
    const { data: post } = await apiClient.get<Post>(`/posts/${params.postId}`);
    return { post };
  },
  head: ({ loaderData }) => ({
    meta: [{ title: `${loaderData?.post.title ?? "Dergi"} - HALO Dergisi` }],
  }),
  component: () => (
    <ClientOnly fallback={null}>
      <Reader />
    </ClientOnly>
  ),
});

const mb = (n: number) => `${(n / 1048576).toFixed(0)} MB`;

function Reader() {
  const { post } = Route.useLoaderData();
  const url = getCdnUrl(post.attachment!);
  const [blob, setBlob] = useState<Blob | null | undefined>(undefined);
  const [progress, setProgress] = useState<{ received: number; total: number | null } | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [controller, setController] = useState<AbortController | null>(null);

  useEffect(() => {
    getCachedIssue(url).then(setBlob, () => setBlob(null));
  }, [url]);

  const download = useCallback(async () => {
    const ctrl = new AbortController();
    setController(ctrl);
    setError(null);
    setProgress({ received: 0, total: null });
    try {
      setBlob(
        await downloadIssue(
          url,
          (received, total) => setProgress({ received, total }),
          ctrl.signal,
        ),
      );
    } catch (e) {
      if (!ctrl.signal.aborted) setError(e instanceof Error ? e.message : "İndirme başarısız.");
    } finally {
      setProgress(null);
      setController(null);
    }
  }, [url]);

  const back = (
    <Button
      variant='ghost'
      size='icon'
      asChild
    >
      <Link
        to='/posts/$postId'
        params={{ postId: post.slug }}
        aria-label='Geri'
      >
        <ArrowLeft />
      </Link>
    </Button>
  );

  if (blob === undefined) return null;

  if (!blob) {
    const pct =
      progress?.total != null ? Math.round((progress.received / progress.total) * 100) : undefined;
    return (
      <div className='mx-auto flex min-h-dvh max-w-md flex-col justify-center gap-4 p-6'>
        <div className='absolute top-2 left-2'>{back}</div>
        <h1 className='text-2xl font-bold'>{post.title}</h1>
        <p className='text-muted-foreground text-sm'>
          Dergi cihazınıza indirilir, böylece internetsiz de okuyabilirsiniz. Dosya büyük olabilir;
          mobil veri kullanıyorsanız dikkat edin.
        </p>
        {error && <p className='text-destructive text-sm'>{error}</p>}
        {progress ? (
          <>
            <Progress value={pct} />
            <p className='text-muted-foreground text-sm'>
              {mb(progress.received)}
              {progress.total ? ` / ${mb(progress.total)}` : ""}
            </p>
            <Button
              variant='outline'
              onClick={() => controller?.abort()}
            >
              Vazgeç
            </Button>
          </>
        ) : (
          <Button onClick={download}>İndir ve Oku</Button>
        )}
      </div>
    );
  }

  return (
    <Pages
      blob={blob}
      slug={post.slug}
      title={post.title}
      back={back}
      onRemove={async () => {
        await removeIssue(url);
        setBlob(null);
      }}
    />
  );
}

function Pages({
  blob,
  slug,
  title,
  back,
  onRemove,
}: {
  blob: Blob;
  slug: string;
  title: string;
  back: React.ReactNode;
  onRemove: () => void;
}) {
  const [count, setCount] = useState(0);
  const [page, setPage] = useState(() => getLastPage(slug) ?? 1);
  const [width, setWidth] = useState(() => Math.min(window.innerWidth, 900));
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const onResize = () => setWidth(Math.min(window.innerWidth, 900));
    window.addEventListener("resize", onResize);
    return () => window.removeEventListener("resize", onResize);
  }, []);

  const go = useCallback(
    (n: number) => {
      if (!count) return;
      const next = Math.min(Math.max(n, 1), count);
      setPage(next);
      saveLastPage(slug, next);
    },
    [count, slug],
  );

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "ArrowRight") go(page + 1);
      if (e.key === "ArrowLeft") go(page - 1);
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [go, page]);

  return (
    <div className='flex h-dvh flex-col'>
      <header className='flex items-center gap-2 border-b px-2 pt-[env(safe-area-inset-top)]'>
        {back}
        <h1 className='flex-1 truncate text-sm font-medium'>{title}</h1>
        <Button
          variant='ghost'
          size='sm'
          onClick={onRemove}
        >
          Cihazdan sil
        </Button>
      </header>
      <div className='flex flex-1 justify-center overflow-auto'>
        {error ? (
          <p className='text-destructive p-6 text-sm'>{error}</p>
        ) : (
          <Document
            file={blob}
            onLoadSuccess={(d) => {
              setCount(d.numPages);
              setPage((p) => Math.min(p, d.numPages));
            }}
            onLoadError={(e) => setError(e.message)}
          >
            <Page
              pageNumber={page}
              width={width}
              renderTextLayer={false}
              renderAnnotationLayer={false}
            />
          </Document>
        )}
      </div>
      {count > 0 && (
        <footer className='flex h-14 items-center gap-2 border-t px-2 pb-[env(safe-area-inset-bottom)]'>
          <Button
            variant='ghost'
            size='icon'
            disabled={page <= 1}
            onClick={() => go(page - 1)}
            aria-label='Önceki sayfa'
          >
            <ChevronLeft />
          </Button>
          <input
            type='range'
            min={1}
            max={count}
            value={page}
            onChange={(e) => go(Number(e.target.value))}
            className='flex-1'
            aria-label='Sayfa'
          />
          <span className='w-16 text-center text-sm tabular-nums'>
            {page} / {count}
          </span>
          <Button
            variant='ghost'
            size='icon'
            disabled={page >= count}
            onClick={() => go(page + 1)}
            aria-label='Sonraki sayfa'
          >
            <ChevronRight />
          </Button>
        </footer>
      )}
    </div>
  );
}
