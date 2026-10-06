export interface NavItem {
  title: string;
  slug: string;
  file: string;
  description?: string;
}

export interface NavSection {
  id: string;
  title: string;
  icon: string; // SVG path data
  items: NavItem[];
}

export interface TocEntry {
  id: string;
  text: string;
  level: 2 | 3;
}

export interface DocMetadata {
  title: string;
  description: string;
  section: string;
  sectionId: string;
  slug: string;
  file: string;
}

export interface DocPage extends DocMetadata {
  toc: TocEntry[];
  content: string; // Raw markdown/MDX content
}
