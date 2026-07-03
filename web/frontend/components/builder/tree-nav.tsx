// web/frontend/components/builder/tree-nav.tsx

"use client";

import { useState } from "react";
import { BuilderModuleInput, BuilderSectionInput } from "@/lib/types";
import { FolderOpen, Plus, Trash2, ArrowUp, ArrowDown, Folder } from "lucide-react";
import { ConfirmModal } from "./confirm-modal";

interface Props {
  draft: BuilderModuleInput;
  onChange: (updated: BuilderModuleInput) => void;
  selectedNode: { type: "module" | "section" | "lab"; sectionId?: string; labId?: string } | null;
  onSelect: (node: { type: "module" | "section" | "lab"; sectionId?: string; labId?: string }) => void;
}

export function TreeNav({ draft, onChange, selectedNode, onSelect }: Props) {
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
  
  const addSection = () => {
    const randomId = `section-${Math.random().toString(36).substring(2, 6)}`;
    const newSection: BuilderSectionInput = {
      id: randomId,
      title: "New Section",
      order: draft.sections.length + 1,
      xp: 10,
      content: "",
      labs: [],
    };
    onChange({
      ...draft,
      sections: [...draft.sections, newSection],
    });
    onSelect({ type: "section", sectionId: randomId });
  };

  const deleteSection = (e: React.MouseEvent, sectionId: string) => {
    e.stopPropagation();
    setModalConfig({
      isOpen: true,
      title: "Delete Section",
      message: "Are you sure you want to delete this section? This cannot be undone.",
      confirmText: "Delete Section",
      type: "danger",
      onCancel: () => setModalConfig((prev) => ({ ...prev, isOpen: false })),
      onConfirm: () => {
        setModalConfig((prev) => ({ ...prev, isOpen: false }));
        const filtered = draft.sections.filter((s) => s.id !== sectionId);
        // Reset order
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
    const temp = updatedSections[idx];
    updatedSections[idx] = updatedSections[targetIdx];
    updatedSections[targetIdx] = temp;

    // Fix orders
    const ordered = updatedSections.map((s, i) => ({ ...s, order: i + 1 }));
    onChange({ ...draft, sections: ordered });
  };

  return (
    <div className="h-full flex flex-col bg-card select-none">
      {/* Module Title Section */}
      <div
        onClick={() => onSelect({ type: "module" })}
        className={`p-4 border-b border-border hover:bg-muted/30 cursor-pointer transition-colors flex items-center gap-2.5 ${
          selectedNode?.type === "module"
            ? "bg-muted/70 border-l-2 border-l-[var(--accent-primary)] font-black text-foreground"
            : "font-bold text-muted-foreground"
        }`}
      >
        <FolderOpen className="h-4.5 w-4.5 text-[var(--accent-primary)] shrink-0" />
        <span className="truncate text-sm">{draft.title || "Untitled Module"}</span>
      </div>

      {/* Syllabus Tree Area */}
      <div className="flex-1 overflow-y-auto p-3 space-y-2">
        <div className="flex items-center justify-between text-[10px] font-bold text-muted-foreground/60 uppercase tracking-widest px-2 mb-1">
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
              const isSectionSelected = selectedNode?.type === "section" && selectedNode.sectionId === sec.id;
              
              return (
                <div key={sec.id} className="space-y-1">
                  {/* Section Node */}
                  <div
                    onClick={() => onSelect({ type: "section", sectionId: sec.id })}
                    className={`group/node flex items-center justify-between px-2.5 py-2.5 rounded-xl cursor-pointer text-xs font-bold transition-all border ${
                      isSectionSelected
                        ? "bg-muted/70 text-foreground border-border/80 shadow-sm"
                        : "hover:bg-muted/30 text-muted-foreground/95 border-transparent"
                    }`}
                  >
                    <div className="flex items-center gap-2 truncate">
                      <Folder className="h-3.5 w-3.5 text-amber-500/80 shrink-0" />
                      <span className="truncate">{sec.title || "Untitled Section"}</span>
                    </div>
                    {/* Action buttons on hover */}
                    <div className="hidden group-hover/node:flex items-center gap-1.5 shrink-0">
                      {secIdx > 0 && (
                        <button
                          onClick={(e) => moveSection(e, secIdx, "up")}
                          className="p-0.5 rounded hover:bg-background/80 hover:text-foreground"
                          title="Move Up"
                        >
                          <ArrowUp className="h-3.5 w-3.5" />
                        </button>
                      )}
                      {secIdx < draft.sections.length - 1 && (
                        <button
                          onClick={(e) => moveSection(e, secIdx, "down")}
                          className="p-0.5 rounded hover:bg-background/80 hover:text-foreground"
                          title="Move Down"
                        >
                          <ArrowDown className="h-3.5 w-3.5" />
                        </button>
                      )}
                      <button
                        onClick={(e) => deleteSection(e, sec.id)}
                        className="p-0.5 rounded hover:bg-background/80 hover:text-rose-400"
                        title="Delete Section"
                      >
                        <Trash2 className="h-3.5 w-3.5" />
                      </button>
                    </div>
                  </div>
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
