import Link from "next/link";
import { Module } from "@/lib/types";
import { DifficultyBadge } from "@/components/challenges/difficulty-badge";
import { Clock, Zap, ChevronRight, CheckCircle2, Crown, ShieldCheck, User } from "lucide-react";

const topicConfig: Record<string, {
  label: string;
  color: string;
  border: string;
  bgDark: string;
  bgLight: string;
}> = {
  docker: {
    label: "Docker",
    color: "#3b82f6",
    border: "#3b82f6",
    bgDark: "rgba(59, 130, 246, 0.12)",
    bgLight: "rgba(59, 130, 246, 0.06)",
  },
  kubernetes: {
    label: "Kubernetes",
    color: "#a855f7",
    border: "#a855f7",
    bgDark: "rgba(168, 85, 247, 0.12)",
    bgLight: "rgba(168, 85, 247, 0.06)",
  },
  linux: {
    label: "Linux",
    color: "#f59e0b",
    border: "#f59e0b",
    bgDark: "rgba(245, 158, 11, 0.12)",
    bgLight: "rgba(245, 158, 11, 0.06)",
  },
  git: {
    label: "Git",
    color: "#f43f5e",
    border: "#f43f5e",
    bgDark: "rgba(244, 63, 94, 0.12)",
    bgLight: "rgba(244, 63, 94, 0.06)",
  },
  jenkins: {
    label: "Jenkins",
    color: "#f97316",
    border: "#f97316",
    bgDark: "rgba(249, 115, 22, 0.12)",
    bgLight: "rgba(249, 115, 22, 0.06)",
  },
  terraform: {
    label: "Terraform",
    color: "#06b6d4",
    border: "#06b6d4",
    bgDark: "rgba(6, 182, 212, 0.12)",
    bgLight: "rgba(6, 182, 212, 0.06)",
  },
  nginx: {
    label: "Nginx",
    color: "#10b981",
    border: "#10b981",
    bgDark: "rgba(16, 185, 129, 0.12)",
    bgLight: "rgba(16, 185, 129, 0.06)",
  },
};

export function ModuleCard({ module }: { module: Module }) {
  const topic = topicConfig[module.topic] ?? topicConfig.docker;
  const progressPct = module.total_sections > 0
    ? Math.round((module.completed_sections / module.total_sections) * 100)
    : 0;
  const isCompleted = module.completed_sections === module.total_sections && module.total_sections > 0;

  return (
    <Link href={`/modules/${module.id}`} className="block h-full cursor-pointer">
      <div
        className="w-full h-full min-h-[260px] p-5 sm:p-6 rounded-none flex flex-col justify-between transition-all duration-150"
        style={{
          border: "none",
          boxShadow: isCompleted ? "inset 0 0 0 2px var(--accent-primary)" : "none",
          backgroundColor: isCompleted ? "rgba(var(--accent-primary-rgb),0.08)" : "transparent",
        }}
        onMouseEnter={(e) => {
          if (!isCompleted) {
            const isDark = document.documentElement.classList.contains("dark");
            e.currentTarget.style.boxShadow = `inset 0 0 0 2px ${topic.border}`;
            e.currentTarget.style.backgroundColor = isDark ? topic.bgDark : topic.bgLight;
          }
        }}
        onMouseLeave={(e) => {
          if (!isCompleted) {
            e.currentTarget.style.boxShadow = "none";
            e.currentTarget.style.backgroundColor = "transparent";
          }
        }}
      >
        {/* Top */}
        <div className="flex-1">
          <div className="flex items-start justify-between gap-2 mb-3">
            <div className="flex flex-wrap gap-2 items-center">
              <span
                className="text-[10px] font-black uppercase tracking-wider px-2 py-0.5 rounded-none"
                style={{
                  backgroundColor: `${topic.color}18`,
                  color: topic.color,
                }}
              >
                {topic.label}
              </span>
              <DifficultyBadge difficulty={module.difficulty} />
            </div>
            {isCompleted && (
              <CheckCircle2 className="h-5 w-5 shrink-0 text-[var(--accent-primary)]" />
            )}
          </div>

          <h3 className="font-bold text-base sm:text-lg text-foreground leading-snug mb-2 group-hover:text-foreground transition-colors">
            {module.title}
          </h3>
          <p className="text-xs text-muted-foreground line-clamp-2 leading-relaxed">
            {module.description}
          </p>

          {/* Author + Verified */}
          <div className="flex items-center gap-2 mt-3 flex-wrap">
            <span
              className="inline-flex items-center gap-1 text-[10px] font-bold px-2 py-0.5 rounded-none"
              style={{
                backgroundColor: `${topic.color}15`,
                color: topic.color,
              }}
            >
              {module.author.is_official
                ? <Crown className="h-2.5 w-2.5" />
                : <User className="h-2.5 w-2.5" />}
              {module.author.name}
            </span>
            {(module.status === "verified" || module.is_official_verified) && (
              <span className="inline-flex items-center gap-1 text-[10px] font-bold px-2 py-0.5 rounded-none bg-emerald-500/15 text-emerald-500">
                <ShieldCheck className="h-2.5 w-2.5" />
                Verified
              </span>
            )}
          </div>
        </div>

        {/* Progress bar */}
        {module.completed_sections > 0 && (
          <div className="pt-3 pb-2">
            <div className="flex justify-between text-xs text-muted-foreground mb-1.5 font-semibold">
              <span>{module.completed_sections}/{module.total_sections} sections</span>
              <span>{progressPct}%</span>
            </div>
            <div className="h-1.5 rounded-none bg-muted overflow-hidden">
              <div
                className="h-full rounded-none transition-all duration-500"
                style={{
                  width: `${progressPct}%`,
                  backgroundColor: "var(--accent-primary)",
                }}
              />
            </div>
          </div>
        )}

        {/* Footer */}
        <div className="pt-3 mt-3 flex items-center justify-between border-t border-border/40">
          <div className="flex items-center gap-4 text-xs text-muted-foreground">
            <span className="flex items-center gap-1 font-mono font-bold text-[var(--accent-primary)]">
              <Zap className="h-3.5 w-3.5" />
              {module.total_xp} XP
            </span>
            <span className="flex items-center gap-1">
              <Clock className="h-3.5 w-3.5" />
              {module.estimated_minutes} min
            </span>
            <span className="hidden sm:inline">
              {module.total_sections} sections
            </span>
          </div>
          <ChevronRight className="h-4 w-4 text-muted-foreground group-hover:text-foreground transition-colors" />
        </div>
      </div>
    </Link>
  );
}