const key = (slug: string) => `reader_page:${slug}`;

export function getLastPage(slug: string): number | null {
  const n = Number(localStorage.getItem(key(slug)));
  return Number.isInteger(n) && n > 0 ? n : null;
}

export function saveLastPage(slug: string, page: number) {
  localStorage.setItem(key(slug), String(page));
}
