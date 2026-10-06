import type { NavSection, NavItem } from "./types";

export const NAV_SECTIONS: NavSection[] = [
  {
    id: "introduction",
    title: "Introduction",
    icon: "M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253",
    items: [
      { title: "Welcome", slug: "introduction/welcome", file: "introduction/welcome.md", description: "What is The Last Deploy?" },
      { title: "Why TLD Exists", slug: "introduction/why-tld", file: "introduction/why-tld.md", description: "The problem we're solving" },
      { title: "Vision", slug: "introduction/vision", file: "introduction/vision.md", description: "Where we're headed" },
      { title: "Philosophy", slug: "introduction/philosophy", file: "introduction/philosophy.md", description: "Our core principles" },
      { title: "FAQ", slug: "introduction/faq", file: "introduction/faq.md", description: "Common questions answered" },
    ],
  },
  {
    id: "getting-started",
    title: "Getting Started",
    icon: "M13 10V3L4 14h7v7l9-11h-7z",
    items: [
      { title: "Installation", slug: "getting-started/installation", file: "getting-started/installation.md", description: "Install the TLD CLI" },
      { title: "Quick Start", slug: "getting-started/quick-start", file: "getting-started/quick-start.md", description: "Zero to first lab in 5 minutes" },
      { title: "Your First Lab", slug: "getting-started/first-lab", file: "getting-started/first-lab.md", description: "Full walkthrough" },
      { title: "Updating", slug: "getting-started/updating", file: "getting-started/updating.md", description: "Keep TLD up to date" },
      { title: "Troubleshooting", slug: "getting-started/troubleshooting", file: "getting-started/troubleshooting.md", description: "Common issues and fixes" },
    ],
  },
  {
    id: "labs",
    title: "Labs",
    icon: "M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z",
    items: [
      { title: "Overview", slug: "labs/overview", file: "labs/overview.md", description: "How labs work" },
      { title: "Learning Paths", slug: "labs/learning-paths", file: "labs/learning-paths.md", description: "Guided tracks" },
      { title: "Beginner Labs", slug: "labs/beginner", file: "labs/beginner.md", description: "Start here" },
      { title: "Intermediate Labs", slug: "labs/intermediate", file: "labs/intermediate.md", description: "Level up" },
      { title: "Advanced Labs", slug: "labs/advanced", file: "labs/advanced.md", description: "Production-grade challenges" },
      { title: "Upcoming Labs", slug: "labs/upcoming", file: "labs/upcoming.md", description: "What's coming next" },
    ],
  },
  {
    id: "cli",
    title: "CLI",
    icon: "M8 9l3 3-3 3m5 0h3M5 20h14a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z",
    items: [
      { title: "Overview", slug: "cli/overview", file: "cli/overview.md", description: "CLI introduction" },
      { title: "tld login", slug: "cli/commands/login", file: "cli/commands/login.md", description: "Authenticate with TLD" },
      { title: "tld logout", slug: "cli/commands/logout", file: "cli/commands/logout.md", description: "Sign out" },
      { title: "tld lab", slug: "cli/commands/lab", file: "cli/commands/lab.md", description: "Start, stop, list labs" },
      { title: "tld check", slug: "cli/commands/check", file: "cli/commands/check.md", description: "Validate your solution" },
      { title: "tld doctor", slug: "cli/commands/doctor", file: "cli/commands/doctor.md", description: "Diagnose your environment" },
      { title: "tld update", slug: "cli/commands/update", file: "cli/commands/update.md", description: "Update the CLI" },
      { title: "tld version", slug: "cli/commands/version", file: "cli/commands/version.md", description: "Show version info" },
      { title: "tld config", slug: "cli/commands/config", file: "cli/commands/config.md", description: "Manage configuration" },
      { title: "Configuration", slug: "cli/configuration", file: "cli/configuration.md", description: "Config file reference" },
      { title: "Authentication", slug: "cli/authentication", file: "cli/authentication.md", description: "Auth flow and tokens" },
      { title: "Examples", slug: "cli/examples", file: "cli/examples.md", description: "Real-world usage patterns" },
    ],
  },
  {
    id: "architecture",
    title: "Architecture",
    icon: "M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10",
    items: [
      { title: "Overview", slug: "architecture/overview", file: "architecture/overview.md", description: "System architecture" },
      { title: "Monorepo", slug: "architecture/monorepo", file: "architecture/monorepo.md", description: "Folder structure" },
      { title: "Backend", slug: "architecture/backend", file: "architecture/backend.md", description: "FastAPI + PostgreSQL" },
      { title: "Frontend", slug: "architecture/frontend", file: "architecture/frontend.md", description: "Next.js dashboard" },
      { title: "CLI", slug: "architecture/cli", file: "architecture/cli.md", description: "Go-based agent" },
      { title: "Lab Engine", slug: "architecture/lab-engine", file: "architecture/lab-engine.md", description: "How labs run" },
      { title: "Database", slug: "architecture/database", file: "architecture/database.md", description: "Schema overview" },
    ],
  },
  {
    id: "contributing",
    title: "Contributing",
    icon: "M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z",
    items: [
      { title: "Development Setup", slug: "contributing/setup", file: "contributing/setup.md", description: "Get your environment ready" },
      { title: "Good First Issues", slug: "contributing/good-first-issues", file: "contributing/good-first-issues.md", description: "Start contributing" },
      { title: "Coding Standards", slug: "contributing/coding-standards", file: "contributing/coding-standards.md", description: "Style and conventions" },
      { title: "Pull Requests", slug: "contributing/pull-requests", file: "contributing/pull-requests.md", description: "PR process" },
      { title: "Code of Conduct", slug: "contributing/code-of-conduct", file: "contributing/code-of-conduct.md", description: "Community standards" },
      { title: "Security Policy", slug: "contributing/security", file: "contributing/security.md", description: "Responsible disclosure" },
    ],
  },
  {
    id: "community",
    title: "Community",
    icon: "M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z",
    items: [
      { title: "Discord", slug: "community/discord", file: "community/discord.md", description: "Join the conversation" },
      { title: "GitHub", slug: "community/github", file: "community/github.md", description: "Star, fork, contribute" },
      { title: "Roadmap", slug: "community/roadmap", file: "community/roadmap.md", description: "What's coming" },
      { title: "Changelog", slug: "community/changelog", file: "community/changelog.md", description: "What changed" },
      { title: "Sponsors", slug: "community/sponsors", file: "community/sponsors.md", description: "Support TLD" },
    ],
  },
  {
    id: "reference",
    title: "Reference",
    icon: "M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z",
    items: [
      { title: "API Reference", slug: "reference/api", file: "reference/api.md", description: "REST API endpoints" },
      { title: "Configuration", slug: "reference/configuration", file: "reference/configuration.md", description: "Config file schema" },
      { title: "Environment Variables", slug: "reference/env-vars", file: "reference/env-vars.md", description: "All env vars" },
      { title: "Exit Codes", slug: "reference/exit-codes", file: "reference/exit-codes.md", description: "CLI exit codes" },
      { title: "Glossary", slug: "reference/glossary", file: "reference/glossary.md", description: "Key terms defined" },
    ],
  },
  {
    id: "learn",
    title: "Learn",
    icon: "M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z",
    items: [
      { title: "DevOps Fundamentals", slug: "learn/devops-fundamentals", file: "learn/devops-fundamentals.md", description: "What is DevOps?" },
      { title: "Docker Concepts", slug: "learn/docker-concepts", file: "learn/docker-concepts.md", description: "Containers explained" },
      { title: "Linux Basics", slug: "learn/linux-basics", file: "learn/linux-basics.md", description: "Essential Linux knowledge" },
      { title: "Kubernetes Explained", slug: "learn/kubernetes-explained", file: "learn/kubernetes-explained.md", description: "Orchestration concepts" },
      { title: "Networking Essentials", slug: "learn/networking-essentials", file: "learn/networking-essentials.md", description: "DNS, HTTP, TCP/IP" },
      { title: "CI/CD Concepts", slug: "learn/cicd-concepts", file: "learn/cicd-concepts.md", description: "Pipelines and automation" },
    ],
  },
];

export function getNavSections(): NavSection[] {
  return NAV_SECTIONS;
}

export function getAllNavItems(): (NavItem & { section: string; sectionId: string; href: string })[] {
  return NAV_SECTIONS.flatMap((section) =>
    section.items.map((item) => ({
      ...item,
      section: section.title,
      sectionId: section.id,
      href: "/" + item.slug,
    }))
  );
}

export const ALL_NAV_ITEMS = getAllNavItems();

export function getNavItemBySlug(slugArr: string[]): (NavItem & { section: string; sectionId: string; href: string }) | undefined {
  const slug = slugArr.join("/");
  return ALL_NAV_ITEMS.find((item) => item.slug === slug);
}

export function getPrevNext(slugArr: string[]): {
  prev: (NavItem & { section: string; href: string }) | null;
  next: (NavItem & { section: string; href: string }) | null;
} {
  const slug = slugArr.join("/");
  const idx = ALL_NAV_ITEMS.findIndex((item) => item.slug === slug);

  return {
    prev: idx > 0 ? ALL_NAV_ITEMS[idx - 1] : null,
    next: idx >= 0 && idx < ALL_NAV_ITEMS.length - 1 ? ALL_NAV_ITEMS[idx + 1] : null,
  };
}
