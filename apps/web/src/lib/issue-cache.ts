const CACHE_NAME = "halo-issues";
export const PDF_ERROR =
  "Sunucu PDF yerine başka bir içerik gönderdi. Lütfen daha sonra tekrar deneyin.";

/** PDFs start with `%PDF` (the spec allows up to 1 KB of junk before it). */
export function looksLikePdf(bytes: Uint8Array): boolean {
  const head = new TextDecoder("latin1").decode(bytes.subarray(0, 1024));
  return head.includes("%PDF");
}

async function blobLooksLikePdf(blob: Blob) {
  return looksLikePdf(new Uint8Array(await blob.slice(0, 1024).arrayBuffer()));
}

/** The saved copy of [url], or null. A saved non-PDF is dropped so the reader offers a fresh download. */
export async function getCachedIssue(url: string): Promise<Blob | null> {
  const cache = await caches.open(CACHE_NAME);
  const res = await cache.match(url);
  if (!res) return null;
  const blob = await res.blob();
  if (!(await blobLooksLikePdf(blob))) {
    await cache.delete(url);
    return null;
  }
  return blob;
}

/** Downloads [url] with progress; nothing is stored unless the whole file is a valid PDF. */
export async function downloadIssue(
  url: string,
  onProgress: (received: number, total: number | null) => void,
  signal?: AbortSignal,
): Promise<Blob> {
  const res = await fetch(url, { signal });
  if (!res.ok || !res.body) throw new Error(`İndirme başarısız (${res.status}).`);
  const total = Number(res.headers.get("content-length")) || null;
  const reader = res.body.getReader();
  const chunks: Uint8Array<ArrayBuffer>[] = [];
  let received = 0;
  for (;;) {
    const { done, value } = await reader.read();
    if (done) break;
    chunks.push(value as Uint8Array<ArrayBuffer>);
    received += value.length;
    onProgress(received, total);
  }
  const blob = new Blob(chunks, { type: "application/pdf" });
  if (!(await blobLooksLikePdf(blob))) throw new Error(PDF_ERROR);
  const cache = await caches.open(CACHE_NAME);
  await cache.put(url, new Response(blob, { headers: { "content-type": "application/pdf" } }));
  void navigator.storage?.persist?.();
  return blob;
}

export async function removeIssue(url: string) {
  await (await caches.open(CACHE_NAME)).delete(url);
}
