export interface SEOConfig {
  title?: string;
  description?: string;
  keywords?: string[];
  author?: string;
  canonical?: string;
  type?: "website" | "article" | "profile";
  image?: string;
  imageAlt?: string;
  publishedTime?: string;
  modifiedTime?: string;
  section?: string;
  tags?: string[];
  locale?: string;
  siteName?: string;
  twitterCard?: "summary" | "summary_large_image" | "app" | "player";
  twitterSite?: string;
  twitterCreator?: string;
  noindex?: boolean;
  nofollow?: boolean;
}

const DEFAULT_SEO: Required<
  Pick<SEOConfig, "locale" | "siteName" | "twitterCard" | "twitterSite" | "type">
> = {
  locale: "tr_TR",
  siteName: "HALO Dergisi",
  twitterCard: "summary_large_image",
  twitterSite: "@haloidergisi",
  type: "website",
};

export function generateMetaTags(config: SEOConfig) {
  const {
    title,
    description,
    keywords,
    author,
    canonical,
    type = DEFAULT_SEO.type,
    image,
    imageAlt,
    publishedTime,
    modifiedTime,
    section,
    tags,
    locale = DEFAULT_SEO.locale,
    siteName = DEFAULT_SEO.siteName,
    twitterCard = DEFAULT_SEO.twitterCard,
    twitterSite = DEFAULT_SEO.twitterSite,
    twitterCreator,
    noindex = false,
    nofollow = false,
  } = config;

  const fullTitle = title ? `${title} | ${siteName}` : siteName;

  // The charset tag is set once in __root.tsx (as React's `charSet`).
  const meta: Array<{ name?: string; property?: string; content?: string }> = [
    { name: "viewport", content: "width=device-width, initial-scale=1" },
  ];

  if (title) {
    meta.push({ name: "title", content: fullTitle });
    meta.push({ property: "og:title", content: title });
    meta.push({ name: "twitter:title", content: title });
  }

  if (description) {
    meta.push({ name: "description", content: description });
    meta.push({ property: "og:description", content: description });
    meta.push({ name: "twitter:description", content: description });
  }

  if (keywords && keywords.length > 0) {
    meta.push({ name: "keywords", content: keywords.join(", ") });
  }

  if (author) {
    meta.push({ name: "author", content: author });
  }

  if (noindex || nofollow) {
    const robotsContent = [noindex && "noindex", nofollow && "nofollow"].filter(Boolean).join(", ");
    meta.push({ name: "robots", content: robotsContent });
  }

  meta.push({ property: "og:type", content: type });
  meta.push({ property: "og:site_name", content: siteName });
  meta.push({ property: "og:locale", content: locale });

  if (canonical) {
    meta.push({ property: "og:url", content: canonical });
  }

  if (image) {
    meta.push({ property: "og:image", content: image });
    meta.push({ name: "twitter:image", content: image });
    if (imageAlt) {
      meta.push({ property: "og:image:alt", content: imageAlt });
      meta.push({ name: "twitter:image:alt", content: imageAlt });
    }
  }

  meta.push({ name: "twitter:card", content: twitterCard });
  if (twitterSite) {
    meta.push({ name: "twitter:site", content: twitterSite });
  }
  if (twitterCreator) {
    meta.push({ name: "twitter:creator", content: twitterCreator });
  }

  if (type === "article") {
    if (publishedTime) {
      meta.push({ property: "article:published_time", content: publishedTime });
    }
    if (modifiedTime) {
      meta.push({ property: "article:modified_time", content: modifiedTime });
    }
    if (author) {
      meta.push({ property: "article:author", content: author });
    }
    if (section) {
      meta.push({ property: "article:section", content: section });
    }
    if (tags && tags.length > 0) {
      tags.forEach((tag) => {
        meta.push({ property: "article:tag", content: tag });
      });
    }
  }

  return meta;
}

export function generateCanonicalUrl(path: string, baseUrl?: string): string {
  const base = baseUrl || (typeof window !== "undefined" ? window.location.origin : "");
  const cleanPath = path.startsWith("/") ? path : `/${path}`;
  return `${base}${cleanPath}`;
}

/** Fields read by {@link generateStructuredData}; each schema type uses a subset. */
export interface StructuredDataInput {
  name?: string;
  url?: string;
  description?: string;
  headline?: string;
  image?: string;
  datePublished?: string | Date | null;
  dateModified?: string | Date | null;
  author?: string;
  authorType?: "Person" | "Organization";
  publisherLogo?: string;
  logo?: string;
  sameAs?: string[];
}

export function generateStructuredData(
  type: "WebSite" | "Article" | "Organization",
  data: StructuredDataInput,
) {
  const baseContext = "https://schema.org";

  switch (type) {
    case "WebSite":
      return {
        "@context": baseContext,
        "@type": "WebSite",
        name: data.name || DEFAULT_SEO.siteName,
        url: data.url,
        description: data.description,
        potentialAction: {
          "@type": "SearchAction",
          target: {
            "@type": "EntryPoint",
            urlTemplate: `${data.url}/posts?q={search_term_string}`,
          },
          "query-input": "required name=search_term_string",
        },
      };

    case "Article":
      return {
        "@context": baseContext,
        "@type": "Article",
        headline: data.headline,
        description: data.description,
        image: data.image,
        datePublished: data.datePublished,
        dateModified: data.dateModified || data.datePublished,
        author: {
          "@type": data.authorType || "Person",
          name: data.author,
        },
        publisher: {
          "@type": "Organization",
          name: DEFAULT_SEO.siteName,
          logo: {
            "@type": "ImageObject",
            url: data.publisherLogo,
          },
        },
        mainEntityOfPage: {
          "@type": "WebPage",
          "@id": data.url,
        },
      };

    case "Organization":
      return {
        "@context": baseContext,
        "@type": "Organization",
        name: data.name || DEFAULT_SEO.siteName,
        url: data.url,
        logo: data.logo,
        description: data.description,
        sameAs: data.sameAs || [],
      };

    default:
      return null;
  }
}
