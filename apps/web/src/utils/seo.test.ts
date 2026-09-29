import { describe, expect, it } from "vitest";

import { generateCanonicalUrl, generateMetaTags } from "./seo";

const find = (meta: ReturnType<typeof generateMetaTags>, key: string) =>
  meta.find((m) => m.name === key || m.property === key)?.content;

describe("generateMetaTags", () => {
  it("suffixes the page title with the site name", () => {
    const meta = generateMetaTags({ title: "Sayı 5", description: "Yeni sayı" });
    expect(find(meta, "title")).toBe("Sayı 5 | HALO Dergisi");
    expect(find(meta, "og:title")).toBe("Sayı 5");
    expect(find(meta, "description")).toBe("Yeni sayı");
    expect(find(meta, "og:locale")).toBe("tr_TR");
  });

  it("adds robots only when indexing is restricted", () => {
    expect(find(generateMetaTags({}), "robots")).toBeUndefined();
    expect(find(generateMetaTags({ noindex: true, nofollow: true }), "robots")).toBe(
      "noindex, nofollow",
    );
  });

  it("emits article metadata only for articles", () => {
    const article = generateMetaTags({ type: "article", tags: ["şiir", "öykü"] });
    expect(article.filter((m) => m.property === "article:tag")).toHaveLength(2);
    expect(find(generateMetaTags({ tags: ["şiir"] }), "article:tag")).toBeUndefined();
  });
});

describe("generateCanonicalUrl", () => {
  it("joins the base and path with exactly one slash", () => {
    expect(generateCanonicalUrl("posts/x", "https://halo.test")).toBe("https://halo.test/posts/x");
    expect(generateCanonicalUrl("/posts/x", "https://halo.test")).toBe("https://halo.test/posts/x");
  });
});
