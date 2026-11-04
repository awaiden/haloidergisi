import { createFileRoute } from "@tanstack/react-router";

import Markdown from "@/components/markdown";
import content from "@/contents/terms.md?raw";
import { pageHead } from "@/utils/seo";

export const Route = createFileRoute("/_landing/terms")({
  head: () =>
    pageHead(
      "/terms",
      "Kullanım Şartları",
      "HALO Dergisi web sitesi ve uygulamasının kullanım şartları.",
    ),
  component: RouteComponent,
});

function RouteComponent() {
  return (
    <div className='container max-w-3xl py-20'>
      <Markdown>{content}</Markdown>
    </div>
  );
}
