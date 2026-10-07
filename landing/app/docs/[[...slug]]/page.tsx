import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { headers } from "next/headers";
import { getPage } from "@/lib/docs/content";
import { renderMarkdown } from "@/lib/docs/markdown";
import { getPrevNext } from "@/lib/docs-nav";
import OnPageToc from "@/components/docs/on-page-toc";
import PrevNextNav from "@/components/docs/prev-next-nav";
import Badge from "@/components/docs/badge";

interface PageProps {
  params: Promise<{ slug?: string[] }>;
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { slug } = await params;
  if (!slug) return {};
  const page = getPage(slug);
  if (!page) return {};
  return {
    title: page.title,
    description: page.description,
  };
}

export default async function DocsPage({ params }: PageProps) {
  const { slug } = await params;
  if (!slug) notFound();

  const page = getPage(slug);
  if (!page) notFound();

  const { prev, next } = getPrevNext(slug);

  const headersList = await headers();
  const host = headersList.get("host") || "";
  const isSubdomain = host.startsWith("docs.") || host.includes("docs.localhost");

  return (
    <>
      {/* Main content */}
      <main className="docs-content-area">
        {/* Page header */}
        <div className="docs-page-title-block">
          <div className="docs-page-meta">
            <Badge variant="available">{page.section}</Badge>
          </div>
          <h1 className="docs-page-title">
            {page.title}
          </h1>
          <p className="docs-page-description">{page.description}</p>
        </div>

        {/* Content */}
        {renderMarkdown(page.content)}

        {/* Prev/Next */}
        <PrevNextNav isSubdomain={isSubdomain} prev={prev} next={next} />
      </main>

      {/* On-page TOC */}
      {page.toc.length > 0 && <OnPageToc entries={page.toc} />}
    </>
  );
}
