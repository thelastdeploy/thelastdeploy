import {
  getNavSections,
  getAllNavItems,
  getNavItemBySlug,
  getPrevNext as getPrevNextNav,
} from "./docs/navigation";

export interface NavItem {
  title: string;
  href: string;
  description?: string;
}

export interface NavSection {
  id: string;
  title: string;
  icon: string;
  items: NavItem[];
}

export const NAV_SECTIONS: NavSection[] = getNavSections().map((sec) => ({
  id: sec.id,
  title: sec.title,
  icon: sec.icon,
  items: sec.items.map((item) => ({
    title: item.title,
    href: "/" + item.slug,
    description: item.description,
  })),
}));

export const ALL_NAV_ITEMS: (NavItem & { section: string; sectionId: string })[] =
  getAllNavItems().map((item) => ({
    title: item.title,
    href: item.href,
    description: item.description,
    section: item.section,
    sectionId: item.sectionId,
  }));

export function getNavItem(slug: string[]): (NavItem & { section: string; sectionId: string }) | undefined {
  const item = getNavItemBySlug(slug);
  if (!item) return undefined;
  return {
    title: item.title,
    href: item.href,
    description: item.description,
    section: item.section,
    sectionId: item.sectionId,
  };
}

export function getPrevNext(slug: string[]): {
  prev: (NavItem & { section: string }) | null;
  next: (NavItem & { section: string }) | null;
} {
  const res = getPrevNextNav(slug);
  return {
    prev: res.prev ? { title: res.prev.title, href: res.prev.href, section: res.prev.section } : null,
    next: res.next ? { title: res.next.title, href: res.next.href, section: res.next.section } : null,
  };
}
