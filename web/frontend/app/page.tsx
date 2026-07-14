// web/frontend/app/page.tsx

"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth";
import Link from "next/link";
import { ArrowRight, Container, GitBranch, Monitor, Server } from "lucide-react";
import { LoadingSpinner } from "@/components/shared/loading-spinner";

const features = [
  {
    icon: Container, title: "Docker",
    description: "From hello-world to multi-stage builds.",
    bg: "var(--topic-docker)", border: "var(--topic-docker-border)", color: "var(--topic-docker-text)",
    glowColor: "59,130,246",
  },
  {
    icon: Server, title: "Kubernetes",
    description: "Deploy and scale on real clusters.",
    bg: "var(--topic-kubernetes)", border: "var(--topic-kubernetes-border)", color: "var(--topic-kubernetes-text)",
    glowColor: "168,85,247",
  },
  {
    icon: Monitor, title: "Linux",
    description: "Permissions, processes, networking.",
    bg: "var(--topic-linux)", border: "var(--topic-linux-border)", color: "var(--topic-linux-text)",
    glowColor: "245,158,11",
  },
  {
    icon: GitBranch, title: "Git",
    description: "Version control, repositories, commits.",
    bg: "var(--topic-git)", border: "var(--topic-git-border)", color: "var(--topic-git-text)",
    glowColor: "236,72,153",
  },
];

const terminalLines = [
  { prefix: "❯", text: "tld sync", type: "cmd" },
  { prefix: "  ✓", text: "docker-hello", type: "ok" },
  { prefix: "  ✓", text: "k8s-first-pod", type: "ok" },
  { prefix: "❯", text: "tld start docker-hello", type: "cmd" },
  { prefix: "  ", text: "Lab ready. Follow the steps above.", type: "muted" },
  { prefix: "❯", text: "tld check", type: "cmd" },
  { prefix: "  ✅", text: "PASSED — 🎉 +50 XP awarded!", type: "success" },
];

function AnimatedTerminal() {
  const [visible, setVisible] = useState(0);

  useEffect(() => {
    if (visible >= terminalLines.length) return;
    const delay = visible === 0 ? 500 : 500 + visible * 350;
    const t = setTimeout(() => setVisible((v) => v + 1), delay);
    return () => clearTimeout(t);
  }, [visible]);

  return (
    <div className="lg:col-span-2 w-full rounded-2xl border border-border bg-card overflow-hidden shadow-2xl relative group">
      {/* Glow ring on hover */}
      <div className="absolute -inset-px rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-500 bg-gradient-to-br from-[rgba(var(--accent-primary-rgb),0.15)] via-transparent to-[rgba(var(--accent-primary-rgb),0.05)] pointer-events-none" />

      {/* Title bar */}
      <div className="flex items-center gap-1.5 px-4 py-3 border-b border-border bg-muted/30">
        <span className="h-3 w-3 rounded-full bg-[#ff5f57]" />
        <span className="h-3 w-3 rounded-full bg-[#febc2e]" />
        <span className="h-3 w-3 rounded-full bg-[#28c840]" />
        <span className="ml-3 text-xs text-muted-foreground font-mono">tld — zsh</span>
      </div>

      <div className="px-6 py-6 space-y-2.5 font-mono text-xs sm:text-sm text-foreground min-h-[180px]">
        {terminalLines.slice(0, visible).map((line, i) => (
          <p
            key={i}
            className={
              line.type === "cmd"
                ? "text-foreground"
                : line.type === "ok"
                ? "text-muted-foreground"
                : line.type === "success"
                ? "font-bold text-[var(--accent-primary)]"
                : "text-muted-foreground"
            }
            style={{ animation: "fadeSlideIn 0.25s ease forwards" }}
          >
            <span className={line.type === "cmd" ? "text-[var(--accent-primary)]" : ""}>{line.prefix}</span>
            {" "}
            <span>{line.text}</span>
          </p>
        ))}
        {visible < terminalLines.length && (
          <span className="inline-block w-[7px] h-4 bg-[var(--accent-primary)] opacity-80 align-middle animate-pulse rounded-sm" />
        )}
      </div>
    </div>
  );
}

export default function HomePage() {
  const { user, loading } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (!loading && user) router.replace("/dashboard");
  }, [user, loading, router]);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[calc(100vh-64px)]">
        <LoadingSpinner />
      </div>
    );
  }
  if (user) return null;

  return (
    <div className="flex flex-col min-h-[calc(100vh-64px)] justify-between relative overflow-hidden">
      {/* Global page glow blobs */}
      <div className="pointer-events-none absolute -top-32 -left-32 w-96 h-96 rounded-full bg-[var(--accent-primary)]/5 blur-[120px]" />
      <div className="pointer-events-none absolute top-48 right-0 w-80 h-80 rounded-full bg-blue-500/5 blur-[120px]" />

      {/* Hero */}
      <section className="max-w-6xl mx-auto px-6 pt-20 pb-16 w-full grid grid-cols-1 lg:grid-cols-5 gap-12 items-center relative z-10">
        <div className="flex flex-col items-start gap-6 lg:col-span-3">
          <span
            className="text-xs font-bold uppercase tracking-widest px-3 py-1.5 rounded-full border border-[rgba(var(--accent-primary-rgb),0.3)] bg-[rgba(var(--accent-primary-rgb),0.06)] text-[var(--accent-primary)]"
            style={{ animation: "fadeSlideIn 0.5s ease forwards" }}
          >
            Open Source · Free Forever
          </span>

          <h1
            className="text-5xl sm:text-6xl font-black tracking-tight leading-[1.1] text-foreground"
            style={{ animation: "fadeSlideIn 0.6s ease forwards" }}
          >
            Learn DevOps
            <br />
            by <span className="neon-text">doing it.</span>
          </h1>

          <p
            className="text-lg text-muted-foreground leading-relaxed max-w-lg"
            style={{ animation: "fadeSlideIn 0.7s ease forwards" }}
          >
            Hands-on challenges for Docker, Kubernetes, Linux, and Git.
            Run labs locally — no cloud account, no credit card, no BS.
          </p>

          <div
            className="flex flex-wrap items-center gap-3 mt-2"
            style={{ animation: "fadeSlideIn 0.8s ease forwards" }}
          >
            <Link
              href="/modules"
              className="relative flex items-center gap-2 px-6 py-3 rounded-xl font-bold text-background bg-[var(--accent-primary)] hover:opacity-90 transition-all hover:scale-105 neon-glow text-white dark:text-black overflow-hidden group"
            >
              <span className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-700" />
              <span className="relative flex items-center gap-2">
                Browse Challenges
                <ArrowRight className="h-4 w-4" />
              </span>
            </Link>
            <Link
              href="/register"
              className="flex items-center gap-2 px-6 py-3 rounded-xl font-bold text-foreground border border-border bg-card hover:bg-muted hover:border-foreground/20 transition-all hover:scale-[1.02]"
            >
              Create account
            </Link>
          </div>

          {/* Social proof row */}
          <div className="flex items-center gap-3 text-sm text-muted-foreground" style={{ animation: "fadeSlideIn 0.9s ease forwards" }}>
            <div className="flex -space-x-1.5">
              {["#16a34a", "#3b82f6", "#f59e0b", "#ec4899"].map((c, i) => (
                <div key={i} className="w-6 h-6 rounded-full border-2 border-background" style={{ background: c }} />
              ))}
            </div>
            <span><strong className="text-foreground">2,400+</strong> engineers actively learning</span>
          </div>
        </div>

        {/* Terminal */}
        <AnimatedTerminal />
      </section>

      {/* Feature cards */}
      <section className="max-w-6xl mx-auto px-6 pb-20 w-full relative z-10">
        <h2 className="text-2xl sm:text-3xl font-black mb-8 text-foreground">
          Four tracks. <span className="text-muted-foreground">One platform.</span>
        </h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
          {features.map(({ icon: Icon, title, description, bg, border, color, glowColor }) => (
            <div
              key={title}
              className="rounded-2xl p-6 border flex flex-col gap-4 hover:scale-[1.03] transition-all duration-300 shadow-sm cursor-default relative overflow-hidden group"
              style={{ backgroundColor: bg, borderColor: border }}
            >
              {/* Radial glow on hover */}
              <div
                className="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-300 rounded-2xl pointer-events-none"
                style={{ background: `radial-gradient(ellipse at 50% 50%, rgba(${glowColor},0.08) 0%, transparent 70%)` }}
              />
              <div className="w-10 h-10 rounded-xl flex items-center justify-center bg-background/50 border border-border/20 relative z-10 group-hover:scale-110 transition-transform duration-300">
                <Icon className="h-5 w-5" style={{ color }} />
              </div>
              <div className="relative z-10">
                <h3 className="font-bold text-foreground text-base">{title}</h3>
                <p className="text-sm text-muted-foreground mt-1.5 leading-relaxed">{description}</p>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* CTA */}
      <section className="border-t border-border py-12 w-full relative overflow-hidden">
        {/* CTA background glow */}
        <div className="absolute inset-0 bg-muted/20" />
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_50%_100%_at_80%_50%,rgba(var(--accent-primary-rgb),0.06),transparent)] pointer-events-none" />

        <div className="max-w-6xl mx-auto px-6 flex flex-col sm:flex-row items-center justify-between gap-6 relative z-10">
          <div>
            <h2 className="text-2xl font-black text-foreground">Ready to start?</h2>
            <p className="text-muted-foreground mt-1">Install the agent and pick your first challenge.</p>
          </div>
          <Link
            href="/modules"
            className="relative flex items-center gap-2 px-6 py-3 rounded-xl font-bold text-background bg-[var(--accent-primary)] hover:opacity-90 hover:scale-105 transition-all text-white dark:text-black neon-glow overflow-hidden group"
          >
            <span className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-700" />
            <span className="relative flex items-center gap-2">
              View all challenges <ArrowRight className="h-4 w-4" />
            </span>
          </Link>
        </div>
      </section>
    </div>
  );
}