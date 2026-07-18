// web/frontend/components/builder/tree-nav.tsx

"use client";

import { useState } from "react";
import { BuilderModuleInput, BuilderSectionInput, BuilderLabInput } from "@/lib/types";
import {
  FolderOpen,
  Plus,
  Trash2,
  ArrowUp,
  ArrowDown,
  Folder,
  ChevronRight,
  ChevronDown,
  FlaskConical,
} from "lucide-react";
import { ConfirmModal } from "./confirm-modal";

interface Props {
  draft: BuilderModuleInput;
  onChange: (updated: BuilderModuleInput) => void;
  selectedNode: { type: "module" | "section" | "lab"; sectionId?: string; labId?: string } | null;
  onSelect: (node: { type: "module" | "section" | "lab"; sectionId?: string; labId?: string }) => void;
}

function makeLabId() {
  return `lab-${Math.random().toString(36).substring(2, 8)}`;
}

function makeSectionId() {
  return `section-${Math.random().toString(36).substring(2, 6)}`;
}

export function TreeNav({ draft, onChange, selectedNode, onSelect }: Props) {
  // Track which sections are expanded in the tree
  const [expandedSections, setExpandedSections] = useState<Set<string>>(new Set());

  const [modalConfig, setModalConfig] = useState<{
    isOpen: boolean;
    title: string;
    message: string;
    confirmText?: string;
    type?: "danger" | "warning" | "info" | "success";
    onConfirm: () => void;
    onCancel?: () => void;
  }>({
    isOpen: false,
    title: "",
    message: "",
    onConfirm: () => {},
  });

  // ── Section operations ──────────────────────────────────────────────────────

  const addSection = () => {
    const randomId = makeSectionId();
    const newSection: BuilderSectionInput = {
      id: randomId,
      title: "New Section",
      order: draft.sections.length + 1,
      xp: 10,
      content: "",
      labs: [],
    };
    onChange({ ...draft, sections: [...draft.sections, newSection] });
    onSelect({ type: "section", sectionId: randomId });
    // Auto-expand new section
    setExpandedSections((prev) => new Set([...prev, randomId]));
  };

  const deleteSection = (e: React.MouseEvent, sectionId: string) => {
    e.stopPropagation();
    setModalConfig({
      isOpen: true,
      title: "Delete Section",
      message: "Are you sure you want to delete this section and all its labs? This cannot be undone.",
      confirmText: "Delete Section",
      type: "danger",
      onCancel: () => setModalConfig((prev) => ({ ...prev, isOpen: false })),
      onConfirm: () => {
        setModalConfig((prev) => ({ ...prev, isOpen: false }));
        const filtered = draft.sections.filter((s) => s.id !== sectionId);
        const ordered = filtered.map((s, idx) => ({ ...s, order: idx + 1 }));
        onChange({ ...draft, sections: ordered });
        onSelect({ type: "module" });
      },
    });
  };

  const moveSection = (e: React.MouseEvent, idx: number, direction: "up" | "down") => {
    e.stopPropagation();
    const targetIdx = direction === "up" ? idx - 1 : idx + 1;
    if (targetIdx < 0 || targetIdx >= draft.sections.length) return;
    const updatedSections = [...draft.sections];
    [updatedSections[idx], updatedSections[targetIdx]] = [updatedSections[targetIdx], updatedSections[idx]];
    onChange({ ...draft, sections: updatedSections.map((s, i) => ({ ...s, order: i + 1 })) });
  };

  // ── Lab operations ──────────────────────────────────────────────────────────

  const toggleSectionExpand = (e: React.MouseEvent, sectionId: string) => {
    e.stopPropagation();
    setExpandedSections((prev) => {
      const next = new Set(prev);
      if (next.has(sectionId)) next.delete(sectionId);
      else next.add(sectionId);
      return next;
    });
  };

  const addLab = (e: React.MouseEvent, sectionId: string) => {
    e.stopPropagation();
    const labId = makeLabId();
    const newLab: BuilderLabInput = {
      id: labId,
      title: "New Lab",
      order: 1,
      xp: 30,
      estimated_minutes: 10,
      setup_type: "shell",
      seed_commands: [],
      validator_script: "#!/bin/bash\n# Write your validation script here\n# Exit 0 = pass, non-zero = fail\n\nexit 0\n",
      cleanup_script: "#!/bin/bash\n# Restore the environment to its original state\n",
    };
    const updatedSections = draft.sections.map((s) => {
      if (s.id !== sectionId) return s;
      const updatedLabs = [...s.labs, { ...newLab, order: s.labs.length + 1 }];
      return { ...s, labs: updatedLabs };
    });
    onChange({ ...draft, sections: updatedSections });
    // Ensure section is expanded
    setExpandedSections((prev) => new Set([...prev, sectionId]));
    onSelect({ type: "lab", sectionId, labId });
  };

  const deleteLab = (e: React.MouseEvent, sectionId: string, labId: string) => {
    e.stopPropagation();
    setModalConfig({
      isOpen: true,
      title: "Delete Lab",
      message: "Are you sure you want to delete this lab? This cannot be undone.",
      confirmText: "Delete Lab",
      type: "danger",
      onCancel: () => setModalConfig((prev) => ({ ...prev, isOpen: false })),
      onConfirm: () => {
        setModalConfig((prev) => ({ ...prev, isOpen: false }));
        const updatedSections = draft.sections.map((s) => {
          if (s.id !== sectionId) return s;
          const filtered = s.labs.filter((l) => l.id !== labId);
          return { ...s, labs: filtered.map((l, i) => ({ ...l, order: i + 1 })) };
        });
        onChange({ ...draft, sections: updatedSections });
        onSelect({ type: "section", sectionId });
      },
    });
  };

  const moveLab = (e: React.MouseEvent, sectionId: string, labIdx: number, direction: "up" | "down") => {
    e.stopPropagation();
    const updatedSections = draft.sections.map((s) => {
      if (s.id !== sectionId) return s;
      const targetIdx = direction === "up" ? labIdx - 1 : labIdx + 1;
      if (targetIdx < 0 || targetIdx >= s.labs.length) return s;
      const updatedLabs = [...s.labs];
      [updatedLabs[labIdx], updatedLabs[targetIdx]] = [updatedLabs[targetIdx], updatedLabs[labIdx]];
      return { ...s, labs: updatedLabs.map((l, i) => ({ ...l, order: i + 1 })) };
    });
    onChange({ ...draft, sections: updatedSections });
  };

  // ── Render ──────────────────────────────────────────────────────────────────

  return (
    <div className="h-full flex flex-col bg-card select-none">
      {/* Module root node */}
      <div
        onClick={() => onSelect({ type: "module" })}
        className={`p-4 border-b border-border hover:bg-muted/30 cursor-pointer transition-colors flex items-center gap-2.5 ${
          selectedNode?.type === "module"
            ? "bg-muted/70 border-l-2 border-l-[var(--accent-primary)] font-black text-foreground"
            : "font-bold text-muted-foreground"
        }`}
      >
        <FolderOpen className="h-4 w-4 text-[var(--accent-primary)] shrink-0" />
        <span className="truncate text-sm">{draft.title || "Untitled Module"}</span>
      </div>

      {/* Tree area */}
      <div className="flex-1 overflow-y-auto p-3 space-y-1">
        {/* Header row */}
        <div className="flex items-center justify-between text-[10px] font-bold text-muted-foreground/60 uppercase tracking-widest px-2 mb-2">
          <span>Module Tree</span>
          <button
            onClick={addSection}
            className="hover:text-[var(--accent-primary)] transition-colors cursor-pointer flex items-center gap-0.5 text-[10px] font-bold"
            title="Add Section"
          >
            <Plus className="h-3.5 w-3.5" /> Add
          </button>
        </div>

        {draft.sections.length === 0 ? (
          <div className="text-[11px] text-muted-foreground/50 text-center py-6 border border-dashed border-border rounded-xl">
            Empty syllabus.
          </div>
        ) : (
          <div className="space-y-1">
            {draft.sections.map((sec, secIdx) => {
              const isSectionSelected =
                selectedNode?.type === "section" && selectedNode.sectionId === sec.id;
              const isExpanded = expandedSections.has(sec.id);

              return (
                <div key={sec.id} className="space-y-0.5">
                  {/* Section node */}
                  <div
                    onClick={() => onSelect({ type: "section", sectionId: sec.id })}
                    className={`group/node flex items-center justify-between px-2 py-2 rounded-xl cursor-pointer text-xs font-bold transition-all border ${
                      isSectionSelected
                        ? "bg-muted/70 text-foreground border-border/80 shadow-sm"
                        : "hover:bg-muted/30 text-muted-foreground/95 border-transparent"
                    }`}
                  >
                    {/* Left side: expand chevron + folder icon + title */}
                    <div className="flex items-center gap-1.5 truncate min-w-0">
                      <button
                        onClick={(e) => toggleSectionExpand(e, sec.id)}
                        className="shrink-0 text-muted-foreground/50 hover:text-foreground transition-colors cursor-pointer"
                        title={isExpanded ? "Collapse" : "Expand"}
                      >
                        {isExpanded ? (
                          <ChevronDown className="h-3 w-3" />
                        ) : (
                          <ChevronRight className="h-3 w-3" />
                        )}
                      </button>
                      <Folder className="h-3.5 w-3.5 text-amber-500/80 shrink-0" />
                      <span className="truncate">{sec.title || "Untitled Section"}</span>
                      {sec.labs.length > 0 && (
                        <span className="shrink-0 text-[9px] font-black text-muted-foreground/40 bg-muted/60 px-1 rounded">
                          {sec.labs.length}
                        </span>
                      )}
                    </div>

                    {/* Right side: hover actions */}
                    <div className="hidden group-hover/node:flex items-center gap-1 shrink-0 ml-1">
                      {secIdx > 0 && (
                        <button
                          onClick={(e) => moveSection(e, secIdx, "up")}
                          className="p-0.5 rounded hover:bg-background/80 hover:text-foreground"
                          title="Move Up"
                        >
                          <ArrowUp className="h-3 w-3" />
                        </button>
                      )}
                      {secIdx < draft.sections.length - 1 && (
                        <button
                          onClick={(e) => moveSection(e, secIdx, "down")}
                          className="p-0.5 rounded hover:bg-background/80 hover:text-foreground"
                          title="Move Down"
                        >
                          <ArrowDown className="h-3 w-3" />
                        </button>
                      )}
                      <button
                        onClick={(e) => deleteSection(e, sec.id)}
                        className="p-0.5 rounded hover:bg-background/80 hover:text-rose-400"
                        title="Delete Section"
                      >
                        <Trash2 className="h-3 w-3" />
                      </button>
                    </div>
                  </div>

                  {/* Lab child nodes (only when section is expanded) */}
                  {isExpanded && (
                    <div className="ml-5 space-y-0.5">
                      {sec.labs.map((lab, labIdx) => {
                        const isLabSelected =
                          selectedNode?.type === "lab" &&
                          selectedNode.sectionId === sec.id &&
                          selectedNode.labId === lab.id;

                        return (
                          <div
                            key={lab.id}
                            onClick={() => onSelect({ type: "lab", sectionId: sec.id, labId: lab.id })}
                            className={`group/lab flex items-center justify-between px-2 py-1.5 rounded-lg cursor-pointer text-[11px] font-semibold transition-all border ${
                              isLabSelected
                                ? "bg-[rgba(var(--accent-primary-rgb),0.08)] text-[var(--accent-primary)] border-[rgba(var(--accent-primary-rgb),0.2)]"
                                : "hover:bg-muted/20 text-muted-foreground/80 border-transparent"
                            }`}
                          >
                            <div className="flex items-center gap-1.5 truncate min-w-0">
                              <FlaskConical className="h-3 w-3 text-[var(--accent-primary)]/60 shrink-0" />
                              <span className="truncate">{lab.title || "Untitled Lab"}</span>
                            </div>

                            {/* Lab hover actions */}
                            <div className="hidden group-hover/lab:flex items-center gap-1 shrink-0 ml-1">
                              {labIdx > 0 && (
                                <button
                                  onClick={(e) => moveLab(e, sec.id, labIdx, "up")}
                                  className="p-0.5 rounded hover:bg-background/80 hover:text-foreground"
                                  title="Move Up"
                                >
                                  <ArrowUp className="h-3 w-3" />
                                </button>
                              )}
                              {labIdx < sec.labs.length - 1 && (
                                <button
                                  onClick={(e) => moveLab(e, sec.id, labIdx, "down")}
                                  className="p-0.5 rounded hover:bg-background/80 hover:text-foreground"
                                  title="Move Down"
                                >
                                  <ArrowDown className="h-3 w-3" />
                                </button>
                              )}
                              <button
                                onClick={(e) => deleteLab(e, sec.id, lab.id)}
                                className="p-0.5 rounded hover:bg-background/80 hover:text-rose-400"
                                title="Delete Lab"
                              >
                                <Trash2 className="h-3 w-3" />
                              </button>
                            </div>
                          </div>
                        );
                      })}

                      {/* Add Lab button */}
                      <button
                        onClick={(e) => addLab(e, sec.id)}
                        className="w-full flex items-center gap-1.5 px-2 py-1.5 rounded-lg text-[10px] font-bold text-muted-foreground/50 hover:text-[var(--accent-primary)] hover:bg-[rgba(var(--accent-primary-rgb),0.05)] border border-dashed border-border/60 hover:border-[rgba(var(--accent-primary-rgb),0.3)] transition-all cursor-pointer"
                        title="Add Lab to this section"
                      >
                        <Plus className="h-3 w-3" />
                        Add Lab
                      </button>
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}
      </div>

      <ConfirmModal
        isOpen={modalConfig.isOpen}
        title={modalConfig.title}
        message={modalConfig.message}
        type={modalConfig.type}
        confirmText={modalConfig.confirmText}
        onConfirm={modalConfig.onConfirm}
        onCancel={modalConfig.onCancel}
      />
    </div>
  );
}
