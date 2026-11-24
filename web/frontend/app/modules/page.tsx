// web/frontend/app/modules/page.tsx

"use client";

import { useModules } from "@/hooks/use-modules";
import { ModuleGrid } from "@/components/modules/module-grid";
import { LoadingSpinner } from "@/components/shared/loading-spinner";
import { Container, Server, Monitor, GitBranch, Zap, Infinity, Layers, Globe } from "lucide-react";

const topicStats = [
  { key: "docker",     label: "Docker",     icon: Container, bg: "var(--topic-docker)",     borderColorVar: "var(--topic-docker-border)",     color: "var(--topic-docker-text)" },
  { key: "kubernetes", label: "Kubernetes", icon: Server,    bg: "var(--topic-kubernetes)", borderColorVar: "var(--topic-kubernetes-border)", color: "var(--topic-kubernetes-text)" },
  { key: "linux",      label: "Linux",      icon: Monitor,   bg: "var(--topic-linux)",      borderColorVar: "var(--topic-linux-border)",      color: "var(--topic-linux-text)" },
  { key: "git",        label: "Git",        icon: GitBranch, bg: "var(--topic-git)",        borderColorVar: "var(--topic-git-border)",        color: "var(--topic-git-text)" },
  { key: "terraform",  label: "Terraform",  icon: Layers,    bg: "var(--topic-terraform)",  borderColorVar: "var(--topic-terraform-border)",  color: "var(--topic-terraform-text)" },
  { key: "nginx",      label: "Nginx",      icon: Globe,     bg: "var(--topic-nginx)",      borderColorVar: "var(--topic-nginx-border)",      color: "var(--topic-nginx-text)" },
];

export default function ModulesPage() {
  const { modules, loading, error } = useModules();

  return (
    <div>
      <div className="border-b border-border bg-card/30">
        <div className="max-w-7xl mx-auto px-4 py-12">
          <div className="flex items-start justify-between gap-6 flex-wrap">
            <div>
              <h1 className="text-4xl font-black tracking-tight text-foreground">Modules</h1>
              <p className="mt-2 text-muted-foreground max-w-xl">
                Structured learning paths combining theory and hands-on practice.
                No account needed to browse.
              </p>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 py-10">
        {loading && <LoadingSpinner className="py-20" />}
        {error && <div className="text-center py-20 text-red-400 text-sm">{error}</div>}
        {!loading && !error && <ModuleGrid modules={modules} />}
      </div>
    </div>
  );
}