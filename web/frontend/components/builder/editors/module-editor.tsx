// web/frontend/components/builder/editors/module-editor.tsx

"use client";

import { BuilderModuleInput } from "@/lib/types";
import { IdSlugInput } from "../id-slug-input";

interface Props {
  draft: BuilderModuleInput;
  onChange: (updated: BuilderModuleInput) => void;
  status: string;
}

const topics = [
  { value: "docker", label: "Docker" },
  { value: "kubernetes", label: "Kubernetes" },
  { value: "linux", label: "Linux" },
  { value: "git", label: "Git" },
  { value: "jenkins", label: "Jenkins" },
  { value: "terraform", label: "Terraform" },
  { value: "nginx", label: "Nginx" },
];

const difficulties = [
  { value: "beginner", label: "Beginner" },
  { value: "intermediate", label: "Intermediate" },
  { value: "advanced", label: "Advanced" },
];

export function ModuleEditor({ draft, onChange, status }: Props) {
  const handleFieldChange = (key: keyof BuilderModuleInput, val: any) => {
    onChange({ ...draft, [key]: val });
  };

  const handleTagsChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const split = e.target.value.split(",").map((t) => t.trim());
    onChange({ ...draft, tags: split });
  };

  return (
    <div className="p-6 max-w-2xl mx-auto space-y-6">
      <div>
        <h2 className="text-xl font-black text-foreground">Module Settings</h2>
        <p className="text-xs text-muted-foreground mt-1">Configure global details of your training path.</p>
      </div>

      {status !== "draft" && (
        <div className="p-4 rounded-xl bg-amber-500/10 border border-amber-500/25 text-amber-400 text-xs font-semibold leading-relaxed">
          ⚠️ Note: This module is currently Live. Saving updates will clear its "Verified" status and request a re-review by maintainers.
        </div>
      )}

      <div className="space-y-4">
        {/* Module ID (Immutable if not draft) */}
        <IdSlugInput
          value={draft.id}
          onChange={(val) => handleFieldChange("id", val)}
          currentId={draft.id}
          disabled={status !== "draft"}
          label="Module URL Slug / ID"
          placeholder="docker-networking"
        />

        {/* Title */}
        <div className="space-y-1.5">
          <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider block">
            Module Title
          </label>
          <input
            type="text"
            value={draft.title}
            onChange={(e) => handleFieldChange("title", e.target.value)}
            placeholder="Introduction to Docker Networking"
            className="w-full px-3 py-2.5 rounded-xl border border-border bg-background text-sm text-foreground focus:outline-none focus:border-[var(--accent-primary)] focus:ring-1 focus:ring-[var(--accent-primary)] transition-all"
          />
        </div>

        {/* Description */}
        <div className="space-y-1.5">
          <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider block">
            Description
          </label>
          <textarea
            value={draft.description}
            onChange={(e) => handleFieldChange("description", e.target.value)}
            placeholder="A short summary of what students will learn..."
            rows={3}
            className="w-full px-3 py-2.5 rounded-xl border border-border bg-background text-sm text-foreground focus:outline-none focus:border-[var(--accent-primary)] focus:ring-1 focus:ring-[var(--accent-primary)] transition-all resize-none"
          />
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          {/* Topic */}
          <div className="space-y-1.5">
            <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider block">
              Topic
            </label>
            <select
              value={draft.topic}
              onChange={(e) => handleFieldChange("topic", e.target.value)}
              className="w-full px-3 py-2.5 rounded-xl border border-border bg-background text-sm text-foreground focus:outline-none focus:border-[var(--accent-primary)] focus:ring-1 focus:ring-[var(--accent-primary)] transition-all cursor-pointer"
            >
              {topics.map((t) => (
                <option key={t.value} value={t.value}>
                  {t.label}
                </option>
              ))}
            </select>
          </div>

          {/* Difficulty */}
          <div className="space-y-1.5">
            <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider block">
              Difficulty
            </label>
            <select
              value={draft.difficulty}
              onChange={(e) => handleFieldChange("difficulty", e.target.value)}
              className="w-full px-3 py-2.5 rounded-xl border border-border bg-background text-sm text-foreground focus:outline-none focus:border-[var(--accent-primary)] focus:ring-1 focus:ring-[var(--accent-primary)] transition-all cursor-pointer"
            >
              {difficulties.map((d) => (
                <option key={d.value} value={d.value}>
                  {d.label}
                </option>
              ))}
            </select>
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          {/* Est Minutes */}
          <div className="space-y-1.5">
            <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider block">
              Est. Duration (Minutes)
            </label>
            <input
              type="number"
              value={draft.estimated_minutes || ""}
              onChange={(e) => handleFieldChange("estimated_minutes", parseInt(e.target.value) || null)}
              placeholder="e.g. 45"
              className="w-full px-3 py-2.5 rounded-xl border border-border bg-background text-sm text-foreground focus:outline-none focus:border-[var(--accent-primary)] focus:ring-1 focus:ring-[var(--accent-primary)] transition-all"
            />
          </div>

          {/* Tags */}
          <div className="space-y-1.5">
            <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider block">
              Tags (Comma Separated)
            </label>
            <input
              type="text"
              value={draft.tags.join(", ")}
              onChange={handleTagsChange}
              placeholder="e.g. containers, bridge, routing"
              className="w-full px-3 py-2.5 rounded-xl border border-border bg-background text-sm text-foreground focus:outline-none focus:border-[var(--accent-primary)] focus:ring-1 focus:ring-[var(--accent-primary)] transition-all"
            />
          </div>
        </div>
      </div>
    </div>
  );
}
