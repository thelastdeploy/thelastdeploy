import fs from "fs";
import path from "path";
import type { DocPage } from "./types";
import { getNavItemBySlug } from "./navigation";
import { extractToc } from "./toc";

const DOCS_DIR = path.join(process.cwd(), "docs");

export function parseFrontmatter(fileContent: string): {
  frontmatter: Record<string, string>;
  content: string;
} {
  const match = fileContent.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?([\s\S]*)$/);
  if (!match) return { frontmatter: {}, content: fileContent };

  const yamlBlock = match[1];
  const content = match[2];
  const frontmatter: Record<string, string> = {};

  for (const line of yamlBlock.split("\n")) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith("#")) continue;
    const colonIdx = trimmed.indexOf(":");
    if (colonIdx !== -1) {
      const key = trimmed.slice(0, colonIdx).trim();
      let value = trimmed.slice(colonIdx + 1).trim();
      if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
        value = value.slice(1, -1);
      }
      frontmatter[key] = value;
    }
  }

  return { frontmatter, content };
}

export function getPage(slugArr: string[]): DocPage | null {
  const slug = slugArr.join("/");
  const navItem = getNavItemBySlug(slugArr);

  // Determine file path
  let relativeFilePath = navItem?.file || `${slug}.md`;
  let fullPath = path.join(DOCS_DIR, relativeFilePath);

  if (!fs.existsSync(fullPath)) {
    // Try with .mdx extension if .md fails
    if (fullPath.endsWith(".md")) {
      const mdxPath = fullPath.slice(0, -3) + ".mdx";
      if (fs.existsSync(mdxPath)) {
        fullPath = mdxPath;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  const fileContent = fs.readFileSync(fullPath, "utf-8");
  const { frontmatter, content } = parseFrontmatter(fileContent);

  const title = frontmatter.title || navItem?.title || "Documentation";
  const description = frontmatter.description || navItem?.description || "";
  const section = frontmatter.section || navItem?.section || "Documentation";
  const sectionId = navItem?.sectionId || "docs";
  const toc = extractToc(content);

  return {
    title,
    description,
    section,
    sectionId,
    slug,
    file: relativeFilePath,
    toc,
    content,
  };
}
