// web/frontend/components/builder/module-builder-ide.tsx

"use client";

import { useEffect, useState, useRef, useCallback } from "react";
import { useRouter } from "next/navigation";
import { BuilderModuleInput, BuilderSectionInput, BuilderLabInput } from "@/lib/types";
import { api } from "@/lib/api";
import { TreeNav } from "./tree-nav";
import { LivePreview } from "./live-preview";
import { ModuleEditor } from "./editors/module-editor";
import { SectionEditor } from "./editors/section-editor";
import { LabBuilderEditor } from "./editors/lab-builder-editor";
import { PublishGateModal } from "./publish-gate-modal";
import { ConfirmModal } from "./confirm-modal";
import {
  Save,
  CloudOff,
  CheckCircle2,
  Loader2,
  ChevronLeft,
  ChevronRight,
  Rocket,
  PanelLeft,
  PanelRight,
} from "lucide-react";

// ─── Constants ─────────────────────────────────────────────────────────────────
const SIDEBAR_WIDTH = 224; // px (w-56)
const PREVIEW_MIN = 260;
const PREVIEW_MAX = 700;
const PREVIEW_DEFAULT = 440;

// ─── Types ─────────────────────────────────────────────────────────────────────
interface Props {
  initialData: BuilderModuleInput;
  moduleId: string;
  status: string;
  onRefresh: () => void;
}

type SelectedNode = {
  type: "module" | "section" | "lab";
  sectionId?: string;
  labId?: string;
} | null;

// ─── Component ─────────────────────────────────────────────────────────────────
export function ModuleBuilderIDE({
  initialData,
  moduleId,
  status: initialStatus,
  onRefresh,
}: Props) {
  const router = useRouter();
  const [draft, setDraft] = useState<BuilderModuleInput>(initialData);
  const [selectedNode, setSelectedNode] = useState<SelectedNode>({ type: "module" });
  const [isDirty, setIsDirty] = useState(false);
  const [saveStatus, setSaveStatus] = useState<"saved" | "saving" | "unsaved">("saved");
  const [lastSaved, setLastSaved] = useState<Date | null>(null);
  const [isPublishModalOpen, setIsPublishModalOpen] = useState(false);
  const [publishing, setPublishing] = useState(false);

  // Panel visibility
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const [previewOpen, setPreviewOpen] = useState(true);

  // Draggable preview width
  const [previewWidth, setPreviewWidth] = useState(PREVIEW_DEFAULT);
  const dragRef = useRef<{ startX: number; startWidth: number } | null>(null);
  const workspaceRef = useRef<HTMLDivElement>(null);

  const [modalConfig, setModalConfig] = useState<{
    isOpen: boolean;
    title: string;
    message: string;
    confirmText?: string;
    type?: "danger" | "warning" | "info" | "success";
    onConfirm: () => void;
    onCancel?: () => void;
  }>({ isOpen: false, title: "", message: "", onConfirm: () => {} });

  // ── Drag-to-resize ────────────────────────────────────────────────────────
  const handleDividerMouseDown = useCallback((e: React.MouseEvent) => {
    e.preventDefault();
    dragRef.current = { startX: e.clientX, startWidth: previewWidth };

    const onMouseMove = (ev: MouseEvent) => {
      if (!dragRef.current) return;
      const delta = dragRef.current.startX - ev.clientX; // dragging left = bigger preview
      const next = Math.min(PREVIEW_MAX, Math.max(PREVIEW_MIN, dragRef.current.startWidth + delta));
      setPreviewWidth(next);
    };

    const onMouseUp = () => {
      dragRef.current = null;
      document.removeEventListener("mousemove", onMouseMove);
      document.removeEventListener("mouseup", onMouseUp);
    };

    document.addEventListener("mousemove", onMouseMove);
    document.addEventListener("mouseup", onMouseUp);
  }, [previewWidth]);

  // ── Save logic ────────────────────────────────────────────────────────────
  const triggerSave = async (dataToSave: BuilderModuleInput = draft) => {
    setSaveStatus("saving");
    try {
      await api.saveModule(moduleId, dataToSave);
      setSaveStatus("saved");
      setIsDirty(false);
      setLastSaved(new Date());
    } catch (err) {
      console.error("Save failed:", err);
      setSaveStatus("unsaved");
    }
  };

  const handleDraftChange = (updated: BuilderModuleInput) => {
    setDraft(updated);
    setIsDirty(true);
    setSaveStatus("unsaved");
  };

  const updateActiveSection = (updatedSec: BuilderSectionInput) => {
    const updatedSections = draft.sections.map((s) =>
      s.id === updatedSec.id ? updatedSec : s
    );
    handleDraftChange({ ...draft, sections: updatedSections });
  };

  const updateActiveLab = (sectionId: string, updatedLab: BuilderLabInput) => {
    const updatedSections = draft.sections.map((s) => {
      if (s.id !== sectionId) return s;
      return { ...s, labs: s.labs.map((l) => (l.id === updatedLab.id ? updatedLab : l)) };
    });
    handleDraftChange({ ...draft, sections: updatedSections });
  };

  // ── Unload guard ──────────────────────────────────────────────────────────
  useEffect(() => {
    const handler = (e: BeforeUnloadEvent) => {
      if (isDirty) { e.preventDefault(); e.returnValue = ""; }
    };
    window.addEventListener("beforeunload", handler);
    return () => window.removeEventListener("beforeunload", handler);
  }, [isDirty]);

  const handleManualSave = () => triggerSave(draft);

  // ── Publish ───────────────────────────────────────────────────────────────
  const handlePublishConfirm = async () => {
    setPublishing(true);
    try {
      await api.saveModule(moduleId, draft);
      await api.publishModule(moduleId);
      setIsPublishModalOpen(false);
      setModalConfig({
        isOpen: true,
        title: "Module Published Successfully",
        message: "Your module is now live and awaiting verification by the platform maintainers.",
        type: "success",
        confirmText: "Go to Dashboard",
        onConfirm: () => {
          setModalConfig((p) => ({ ...p, isOpen: false }));
          router.push("/builder");
        },
      });
    } catch (err: any) {
      setModalConfig({
        isOpen: true,
        title: "Publish Error",
        message: err.message || "Failed to publish module. Please try again.",
        type: "danger",
        confirmText: "Dismiss",
        onConfirm: () => setModalConfig((p) => ({ ...p, isOpen: false })),
      });
    } finally {
      setPublishing(false);
    }
  };

  // ── Exit guard ────────────────────────────────────────────────────────────
  const handleExitClick = () => {
    if (isDirty) {
      setModalConfig({
        isOpen: true,
        title: "Unsaved Changes",
        message: "You have unsaved changes. Leaving will discard them. Are you sure?",
        confirmText: "Leave anyway",
        type: "warning",
        onCancel: () => setModalConfig((p) => ({ ...p, isOpen: false })),
        onConfirm: () => {
          setModalConfig((p) => ({ ...p, isOpen: false }));
          router.push("/builder");
        },
      });
    } else {
      router.push("/builder");
    }
  };

  const activeSection =
    selectedNode?.type === "section"
      ? draft.sections.find((s) => s.id === selectedNode.sectionId) || null
      : null;

  const activeLab =
    selectedNode?.type === "lab"
      ? draft.sections
          .find((s) => s.id === selectedNode.sectionId)
          ?.labs.find((l) => l.id === selectedNode.labId) || null
      : null;

  // ── Render ────────────────────────────────────────────────────────────────
  return (
    <div className="flex flex-col h-[calc(100vh-64px)] w-full overflow-hidden bg-background select-none">
      {/* ── TOP BAR ──────────────────────────────────────────────────────── */}
      <header className="h-12 shrink-0 border-b border-border bg-card/80 backdrop-blur-sm flex items-center justify-between px-4 gap-3 z-20">
        {/* Left: back + module title + status */}
        <div className="flex items-center gap-2 min-w-0">
          <button
            onClick={handleExitClick}
            className="flex items-center gap-1 px-2.5 py-1.5 rounded-lg text-xs font-bold text-muted-foreground hover:text-foreground hover:bg-muted transition-all cursor-pointer shrink-0"
          >
            <ChevronLeft className="h-3.5 w-3.5" />
            Dashboard
          </button>
          <div className="w-px h-4 bg-border shrink-0" />
          <span className="text-xs font-black text-foreground truncate max-w-[200px]">
            {draft.title || "Untitled Module"}
          </span>
          {initialStatus === "draft" && (
            <span className="text-[9px] font-black uppercase tracking-wider px-1.5 py-0.5 rounded bg-muted text-muted-foreground border border-border shrink-0">
              Draft
            </span>
          )}
        </div>

        {/* Right: save status + actions */}
        <div className="flex items-center gap-2 shrink-0">
          {/* Save status indicator */}
          <div className="hidden sm:flex items-center gap-1.5 text-[10px] font-bold text-muted-foreground pr-1">
            {saveStatus === "saving" && (
              <>
                <Loader2 className="h-3 w-3 animate-spin text-[var(--accent-primary)]" />
                <span>Saving…</span>
              </>
            )}
            {saveStatus === "saved" && (
              <>
                <CheckCircle2 className="h-3 w-3 text-emerald-500" />
                <span>
                  {lastSaved
                    ? `Saved ${lastSaved.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })}`
                    : "Saved"}
                </span>
              </>
            )}
            {saveStatus === "unsaved" && (
              <>
                <CloudOff className="h-3 w-3 text-amber-500" />
                <span className="text-amber-500">Unsaved</span>
              </>
            )}
          </div>

          <button
            onClick={handleManualSave}
            disabled={saveStatus === "saving" || !isDirty}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg border border-border bg-background hover:bg-muted text-xs font-bold transition-all disabled:opacity-40 cursor-pointer"
          >
            <Save className="h-3.5 w-3.5" />
            Save
          </button>
          <button
            onClick={() => setIsPublishModalOpen(true)}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-bold text-black bg-[var(--accent-primary)] hover:opacity-90 transition-all shadow-sm cursor-pointer"
          >
            <Rocket className="h-3.5 w-3.5" />
            Publish
          </button>
        </div>
      </header>

      {/* ── 3-PANEL WORKSPACE ────────────────────────────────────────────── */}
      <div ref={workspaceRef} className="flex flex-1 overflow-hidden min-h-0 relative select-none">

        {/* ── SIDEBAR ────────────────────────────────────────────────────── */}
        {sidebarOpen ? (
          <aside
            style={{ width: SIDEBAR_WIDTH }}
            className="shrink-0 border-r border-border h-full overflow-hidden flex flex-col relative group/sidebar"
          >
            <TreeNav
              draft={draft}
              onChange={handleDraftChange}
              selectedNode={selectedNode}
              onSelect={setSelectedNode}
            />
            {/* Collapse button — sits at the right edge of sidebar */}
            <button
              onClick={() => setSidebarOpen(false)}
              title="Collapse sidebar"
              className="absolute top-3 right-2 w-6 h-6 rounded-md flex items-center justify-center text-muted-foreground/50 hover:text-foreground hover:bg-muted opacity-0 group-hover/sidebar:opacity-100 transition-all cursor-pointer z-10"
            >
              <PanelLeft className="h-3.5 w-3.5" />
            </button>
          </aside>
        ) : (
          /* Collapsed sidebar — thin strip with expand button */
          <div className="shrink-0 w-8 border-r border-border h-full flex flex-col items-center pt-3 bg-card/30">
            <button
              onClick={() => setSidebarOpen(true)}
              title="Expand sidebar"
              className="w-6 h-6 rounded-md flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-all cursor-pointer"
            >
              <ChevronRight className="h-3.5 w-3.5" />
            </button>
          </div>
        )}

        {/* ── EDITOR ─────────────────────────────────────────────────────── */}
        <main className="flex-1 h-full overflow-hidden min-w-0 select-text">
          {selectedNode?.type === "module" && (
            <div className="h-full overflow-y-auto">
              <ModuleEditor draft={draft} onChange={handleDraftChange} status={initialStatus} />
            </div>
          )}
          {selectedNode?.type === "section" && activeSection && (
            <SectionEditor section={activeSection} onChange={updateActiveSection} />
          )}
          {selectedNode?.type === "lab" && activeLab && selectedNode.sectionId && (
            <LabBuilderEditor
              lab={activeLab}
              onChange={(updated) => updateActiveLab(selectedNode.sectionId!, updated)}
            />
          )}
          {!selectedNode && (
            <div className="h-full flex items-center justify-center text-sm text-muted-foreground/60">
              Select an item from the sidebar to start editing.
            </div>
          )}
        </main>

        {/* ── DRAG DIVIDER + PREVIEW ─────────────────────────────────────── */}
        {previewOpen && (
          <>
            {/* Drag handle */}
            <div
              onMouseDown={handleDividerMouseDown}
              className="w-1 shrink-0 h-full cursor-col-resize relative group/divider hover:bg-[var(--accent-primary)]/20 transition-colors"
              title="Drag to resize"
            >
              {/* Visual dot indicator */}
              <div className="absolute inset-y-0 left-0 right-0 flex items-center justify-center pointer-events-none">
                <div className="w-0.5 h-12 rounded-full bg-border group-hover/divider:bg-[var(--accent-primary)]/50 transition-colors" />
              </div>
            </div>

            {/* Preview panel */}
            <aside
              style={{ width: previewWidth }}
              className="shrink-0 border-l border-border h-full overflow-y-auto flex flex-col relative group/preview select-text"
            >
              <LivePreview selectedNode={selectedNode} draft={draft} />
              {/* Collapse button — sits at the left edge of preview */}
              <button
                onClick={() => setPreviewOpen(false)}
                title="Collapse preview"
                className="absolute top-3 left-2 w-6 h-6 rounded-md flex items-center justify-center text-muted-foreground/50 hover:text-foreground hover:bg-muted opacity-0 group-hover/preview:opacity-100 transition-all cursor-pointer z-10"
              >
                <PanelRight className="h-3.5 w-3.5" />
              </button>
            </aside>
          </>
        )}

        {/* Preview collapsed — expand strip on the right edge */}
        {!previewOpen && (
          <div className="shrink-0 w-8 border-l border-border h-full flex flex-col items-center pt-3 bg-card/30">
            <button
              onClick={() => setPreviewOpen(true)}
              title="Expand preview"
              className="w-6 h-6 rounded-md flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-all cursor-pointer"
            >
              <ChevronLeft className="h-3.5 w-3.5" />
            </button>
          </div>
        )}
      </div>

      {/* ── Modals ───────────────────────────────────────────────────────── */}
      <PublishGateModal
        isOpen={isPublishModalOpen}
        onClose={() => setIsPublishModalOpen(false)}
        onConfirm={handlePublishConfirm}
        draft={draft}
        publishing={publishing}
      />
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
