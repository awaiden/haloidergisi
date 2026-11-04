import { createFileRoute } from "@tanstack/react-router";

import Markdown from "@/components/markdown";
import content from "@/contents/privacy.md?raw";
import { pageHead } from "@/utils/seo";

export const Route = createFileRoute("/_landing/privacy")({
  head: () =>
    pageHead(
      "/privacy",
      "Gizlilik Politikası",
      "HALO Dergisi'nin kişisel verileri nasıl topladığı, kullandığı ve koruduğu.",
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
