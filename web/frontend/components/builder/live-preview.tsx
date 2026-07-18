// web/frontend/components/builder/live-preview.tsx

"use client";

import { BuilderModuleInput } from "@/lib/types";
import { MarkdownRenderer } from "@/components/shared/markdown-renderer";
import { Eye, Clock, Zap, FlaskConical, Terminal, ShieldCheck, RotateCcw, CheckCircle2, XCircle } from "lucide-react";

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

  // ── Lab Summary Preview ──────────────────────────────────────────────────────
  if (selectedNode.type === "lab") {
    const section = draft.sections.find((s) => s.id === selectedNode.sectionId);
    const lab = section?.labs.find((l) => l.id === selectedNode.labId);
    if (!lab) return null;

    const validatorLines = (lab.validator_script || "").split("\n").filter(Boolean).length;
    const cleanupLines = (lab.cleanup_script || "").split("\n").filter(Boolean).length;
    const validatorHasShebang = (lab.validator_script || "").trimStart().startsWith("#!/bin/bash");
    const validatorHasExit0 = /exit\s+0/.test(lab.validator_script || "");
    const validatorOk = validatorHasShebang && validatorHasExit0 && validatorLines > 1;

    return (
      <div className="p-5 space-y-5">
        <p className="text-[10px] font-bold text-muted-foreground/60 uppercase tracking-widest flex items-center gap-1.5">
          <Eye className="h-3 w-3" /> Lab Summary Preview
        </p>

        {/* Lab card */}
        <div className="rounded-2xl border border-border bg-card p-5 shadow-sm flex flex-col gap-4">
          <div className="flex items-start gap-3">
            <div className="w-8 h-8 rounded-lg bg-[rgba(var(--accent-primary-rgb),0.1)] border border-[rgba(var(--accent-primary-rgb),0.2)] flex items-center justify-center shrink-0">
              <FlaskConical className="h-4 w-4 text-[var(--accent-primary)]" />
            </div>
            <div className="min-w-0">
              <h3 className="font-black text-sm text-foreground leading-snug">
                {lab.title || "Untitled Lab"}
              </h3>
              <p className="text-[10px] font-mono text-muted-foreground/60 mt-0.5">{lab.id}</p>
            </div>
          </div>

          {/* Stats row */}
          <div className="flex items-center gap-3 flex-wrap">
            <span className="inline-flex items-center gap-1 text-[10px] font-black px-2 py-1 rounded-lg bg-[rgba(var(--accent-primary-rgb),0.08)] text-[var(--accent-primary)] border border-[rgba(var(--accent-primary-rgb),0.15)]">
              <Zap className="h-3 w-3" /> +{lab.xp} XP
            </span>
            {lab.estimated_minutes && (
              <span className="inline-flex items-center gap-1 text-[10px] font-bold px-2 py-1 rounded-lg bg-muted text-muted-foreground border border-border">
                <Clock className="h-3 w-3" /> ~{lab.estimated_minutes} min
              </span>
            )}
            {lab.seed_commands.length > 0 && (
              <span className="inline-flex items-center gap-1 text-[10px] font-bold px-2 py-1 rounded-lg bg-muted text-muted-foreground border border-border">
                <Terminal className="h-3 w-3" /> {lab.seed_commands.length} seed cmd{lab.seed_commands.length !== 1 ? "s" : ""}
              </span>
            )}
          </div>

          {/* Script status */}
          <div className="space-y-2 pt-1 border-t border-border/40">
            <div className="flex items-center justify-between text-[11px]">
              <span className="flex items-center gap-1.5 text-muted-foreground font-semibold">
                <ShieldCheck className="h-3.5 w-3.5" /> Validator
              </span>
              <span className="flex items-center gap-1">
                {validatorLines === 0 ? (
                  <span className="text-rose-400 font-bold">Not written</span>
                ) : validatorOk ? (
                  <>
                    <CheckCircle2 className="h-3 w-3 text-emerald-400" />
                    <span className="text-emerald-400 font-bold">{validatorLines} lines</span>
                  </>
                ) : (
                  <>
                    <XCircle className="h-3 w-3 text-amber-400" />
                    <span className="text-amber-400 font-bold">{validatorLines} lines (issues detected)</span>
                  </>
                )}
              </span>
            </div>
            <div className="flex items-center justify-between text-[11px]">
              <span className="flex items-center gap-1.5 text-muted-foreground font-semibold">
                <RotateCcw className="h-3.5 w-3.5" /> Cleanup
              </span>
              <span className="text-muted-foreground/60 font-bold">
                {cleanupLines === 0 ? "Not written" : `${cleanupLines} lines`}
              </span>
            </div>
          </div>
        </div>

        <p className="text-[10px] text-muted-foreground/50 leading-relaxed">
          This card summarises the lab. Students see the title and XP on the module learning page. The validator script runs when they execute <code className="font-mono">tld check</code>.
        </p>
      </div>
    );
  }

  return null;
}
