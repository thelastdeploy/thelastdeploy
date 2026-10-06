import type { TocEntry } from "./types";

export function slugifyHeading(text: string): string {
  return text
    .toLowerCase()
    .replace(/[^\w\s-]/g, "")
    .trim()
    .replace(/\s+/g, "-");
}

export function extractToc(markdown: string): TocEntry[] {
  const toc: TocEntry[] = [];
  const lines = markdown.split("\n");
  let inCodeBlock = false;

  for (const line of lines) {
    const trimmed = line.trim();

    if (trimmed.startsWith("```")) {
      inCodeBlock = !inCodeBlock;
      continue;
    }

    if (inCodeBlock) continue;

    if (trimmed.startsWith("## ")) {
      const headingText = trimmed.replace(/^##\s+/, "").trim();
      toc.push({
        id: slugifyHeading(headingText),
        text: headingText,
        level: 2,
      });
    } else if (trimmed.startsWith("### ")) {
      const headingText = trimmed.replace(/^###\s+/, "").trim();
      toc.push({
        id: slugifyHeading(headingText),
        text: headingText,
        level: 3,
      });
    }
  }

  return toc;
}
