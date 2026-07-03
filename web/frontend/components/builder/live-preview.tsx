// web/frontend/components/builder/live-preview.tsx

"use client";

import { BuilderModuleInput } from "@/lib/types";
import { MarkdownRenderer } from "@/components/shared/markdown-renderer";
import { Eye, Clock, Zap } from "lucide-react";

interface Props {
  selectedNode: { type: "module" | "section" | "lab"; sectionId?: string; labId?: string } | null;
  draft: BuilderModuleInput;
}

export function LivePreview({ selectedNode, draft }: Props) {
  if (!selectedNode) {
    return (
      <div className="h-full flex flex-col items-center justify-center text-muted-foreground p-6 text-center text-xs gap-2">
        <Eye className="h-6 w-6 text-muted-foreground/30" />
        <span>Select an item in the sidebar to preview it here.</span>
      </div>
    );
  }

  // ── Module Card Preview ──────────────────────────────────────────────────────
  if (selectedNode.type === "module") {
    const totalXp = draft.sections.reduce((sum, s) => sum + s.xp, 0);

    return (
      <div className="p-5 space-y-5">
        <p className="text-[10px] font-bold text-muted-foreground/60 uppercase tracking-widest flex items-center gap-1.5">
          <Eye className="h-3 w-3" /> Module Card Preview
        </p>

        <div className="rounded-2xl border border-border bg-card p-5 shadow-sm flex flex-col gap-4">
          <div className="flex items-center gap-2 flex-wrap">
            <span className="text-[9px] font-black uppercase tracking-wider px-2 py-0.5 rounded-md bg-[rgba(var(--accent-primary-rgb),0.1)] text-[var(--accent-primary)] border border-[rgba(var(--accent-primary-rgb),0.2)]">
              {draft.topic || "—"}
            </span>
            <span className="text-[9px] font-black uppercase tracking-wider px-2 py-0.5 rounded-md bg-muted text-muted-foreground border border-border">
              {draft.difficulty || "—"}
            </span>
          </div>
          <div>
            <h3 className="font-black text-base text-foreground leading-snug mb-1">
              {draft.title || "Untitled Module"}
            </h3>
            <p className="text-xs text-muted-foreground line-clamp-3 leading-relaxed">
              {draft.description || "No description yet."}
            </p>
          </div>
          <div className="flex items-center justify-between pt-3 border-t border-border/40 text-xs text-muted-foreground">
            <div className="flex items-center gap-3">
              <span className="flex items-center gap-1 font-mono font-bold text-[var(--accent-primary)]">
                <Zap className="h-3 w-3" /> {totalXp} XP
              </span>
              <span className="flex items-center gap-1">
                <Clock className="h-3 w-3" /> {draft.estimated_minutes || 0} min
              </span>
            </div>
            <span className="text-[10px] font-semibold">{draft.sections.length} sections</span>
          </div>
        </div>

        <p className="text-[10px] text-muted-foreground/50 leading-relaxed">
          The card above is how your module will appear on the modules listing page.
        </p>
      </div>
    );
  }

  // ── Section Content Preview ──────────────────────────────────────────────────
  if (selectedNode.type === "section") {
    const section = draft.sections.find((s) => s.id === selectedNode.sectionId);
    if (!section) return null;

    return (
      <div className="flex flex-col h-full">
        {/* Preview Header */}
        <div className="px-5 py-4 border-b border-border bg-card/40 shrink-0">
          <p className="text-[9px] font-black uppercase tracking-widest text-muted-foreground/50 flex items-center gap-1.5 mb-2">
            <Eye className="h-3 w-3" /> Live Preview
          </p>
          <h2 className="text-base font-black text-foreground leading-snug">
            {section.title || "Untitled Section"}
          </h2>
          <div className="flex items-center gap-2 mt-2">
            <span className="inline-flex items-center gap-1 text-[9px] font-black uppercase tracking-wider px-2 py-0.5 rounded-md bg-[rgba(var(--accent-primary-rgb),0.08)] text-[var(--accent-primary)] border border-[rgba(var(--accent-primary-rgb),0.15)]">
              +{section.xp} XP
            </span>
            <span className="inline-flex items-center text-[9px] font-black uppercase tracking-wider px-2 py-0.5 rounded-md bg-muted text-muted-foreground border border-border">
              Reading
            </span>
          </div>
        </div>

        {/* Rendered Markdown — identical to live module page */}
        <div className="flex-1 overflow-y-auto px-5 py-5 min-h-0">
          {section.content && section.content.trim() ? (
            <MarkdownRenderer content={section.content} />
          ) : (
            <div className="flex flex-col items-center justify-center h-40 gap-2 text-center">
              <Eye className="h-6 w-6 text-muted-foreground/20" />
              <p className="text-xs text-muted-foreground/50 italic">
                Start typing in the editor to see the live preview here.
              </p>
            </div>
          )}
        </div>
      </div>
    );
  }

  return null;
}
