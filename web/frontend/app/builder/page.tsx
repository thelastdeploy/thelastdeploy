// web/frontend/app/builder/page.tsx

"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { BuilderDraftListItem } from "@/lib/types";
import { LoadingSpinner } from "@/components/shared/loading-spinner";
import { Plus, BookOpen, Trash2, ArrowLeft, ExternalLink, Award, CheckCircle, Zap } from "lucide-react";
import Link from "next/link";
import { ConfirmModal } from "@/components/builder/confirm-modal";

export default function BuilderDashboard() {
  const { user, loading: authLoading } = useAuth();
  const router = useRouter();
  const [modules, setModules] = useState<BuilderDraftListItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  
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

  useEffect(() => {
    if (authLoading) return;
    if (!user) {
      router.push("/login");
      return;
    }

    const loadModules = async () => {
      try {
        const data = await api.getMyModules();
        setModules(data);
      } catch (err: any) {
        setError(err.message || "Failed to load modules");
      } finally {
        setLoading(false);
      }
    };

    loadModules();
  }, [user, authLoading, router]);

  const handleDelete = (id: string) => {
    setModalConfig({
      isOpen: true,
      title: "Delete Draft",
      message: "Are you sure you want to delete this draft? This cannot be undone.",
      confirmText: "Delete",
      type: "danger",
      onCancel: () => setModalConfig((prev) => ({ ...prev, isOpen: false })),
      onConfirm: async () => {
        setModalConfig((prev) => ({ ...prev, isOpen: false }));
        try {
          await api.deleteModule(id);
          setModules((prev) => prev.filter((m) => m.id !== id));
        } catch (err: any) {
          setModalConfig({
            isOpen: true,
            title: "Error Deleting Draft",
            message: err.message || "Failed to delete module",
            type: "danger",
            confirmText: "Dismiss",
            onConfirm: () => setModalConfig((prev) => ({ ...prev, isOpen: false })),
          });
        }
      },
    });
  };

  if (authLoading || loading) {
    return <LoadingSpinner className="py-40" />;
  }

  if (error) {
    return <div className="text-center py-40 text-red-400 text-sm">{error}</div>;
  }

  const drafts = modules.filter((m) => m.status === "draft");
  const liveModules = modules.filter((m) => m.status !== "draft");

  return (
    <div className="max-w-6xl mx-auto px-6 py-12">
      {/* Header */}
      <div className="flex items-center justify-between mb-10 flex-wrap gap-4">
        <div>
          <div className="flex items-center gap-2 mb-2">
            <Link href="/modules" className="flex items-center gap-1.5 text-xs text-muted-foreground hover:text-foreground transition-colors">
              <ArrowLeft className="h-3 w-3" /> Back to Modules
            </Link>
          </div>
          <h1 className="text-3xl font-black text-foreground">Authoring Dashboard</h1>
          <p className="text-sm text-muted-foreground mt-1">
            Create, manage, and edit your custom learning modules.
          </p>
        </div>
        <Link
          href="/builder/new"
          className="flex items-center gap-2 px-5 py-2.5 rounded-xl text-sm font-bold text-white bg-[var(--accent-primary)] hover:opacity-90 transition-all shadow-md cursor-pointer"
        >
          <Plus className="h-4 w-4" /> Create Module
        </Link>
      </div>

      {/* Live Modules Section */}
      <div className="mb-12">
        <h2 className="text-lg font-black uppercase tracking-wider text-muted-foreground/60 mb-5">
          Live Modules
        </h2>
        {liveModules.length === 0 ? (
          <div className="rounded-2xl border border-dashed border-border p-10 text-center text-muted-foreground text-sm">
            No live modules yet. Finish a draft and publish it to see it here!
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {liveModules.map((m) => (
              <div
                key={m.id}
                className="rounded-2xl border border-border bg-card p-6 shadow-sm hover:shadow-md transition-shadow relative overflow-hidden flex flex-col justify-between min-h-[160px]"
              >
                <div>
                  <div className="flex items-start justify-between gap-4 mb-2">
                    <h3 className="font-black text-lg text-foreground leading-snug">{m.title}</h3>
                    <div className="flex items-center gap-1.5">
                      {m.status === "verified" ? (
                        <span className="inline-flex items-center gap-1 text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-500/15 border border-emerald-500/30 text-emerald-400">
                          <CheckCircle className="h-2.5 w-2.5" /> Verified
                        </span>
                      ) : (
                        <span className="inline-flex items-center gap-1 text-[10px] font-bold px-2 py-0.5 rounded-full bg-amber-500/15 border border-amber-500/30 text-amber-400">
                          <Award className="h-2.5 w-2.5" /> Published (Reviewing)
                        </span>
                      )}
                    </div>
                  </div>
                  <div className="flex items-center gap-4 text-xs text-muted-foreground mb-4">
                    <span className="font-mono text-[var(--accent-primary)] font-bold flex items-center gap-0.5">
                      <Zap className="h-3 w-3" /> {m.total_xp} XP
                    </span>
                    <span className="flex items-center gap-0.5">
                      <BookOpen className="h-3 w-3" /> {m.total_sections} Sections
                    </span>
                  </div>
                </div>

                <div className="flex items-center gap-3 mt-4 pt-4 border-t border-border/40">
                  <Link
                    href={`/modules/${m.id}`}
                    target="_blank"
                    className="flex-1 text-center py-2 rounded-xl text-xs font-bold border border-border text-foreground hover:bg-muted transition-colors flex items-center justify-center gap-1.5"
                  >
                    View Live <ExternalLink className="h-3 w-3" />
                  </Link>
                  <Link
                    href={`/builder/${m.id}/edit`}
                    className="flex-1 text-center py-2 rounded-xl text-xs font-bold text-white bg-zinc-800 hover:bg-zinc-700 transition-colors block"
                  >
                    Edit Module
                  </Link>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Drafts Section */}
      <div>
        <h2 className="text-lg font-black uppercase tracking-wider text-muted-foreground/60 mb-5">
          In-Progress Drafts
        </h2>
        {drafts.length === 0 ? (
          <div className="rounded-2xl border border-dashed border-border p-10 text-center text-muted-foreground text-sm">
            No active drafts. Click "Create Module" to start writing a new one!
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {drafts.map((m) => (
              <div
                key={m.id}
                className="rounded-2xl border border-border bg-card p-6 shadow-sm hover:shadow-md transition-shadow relative overflow-hidden flex flex-col justify-between min-h-[160px]"
              >
                <div>
                  <div className="flex items-start justify-between gap-4 mb-2">
                    <h3 className="font-black text-lg text-foreground leading-snug">{m.title}</h3>
                    <span className="inline-flex items-center gap-1 text-[10px] font-bold px-2 py-0.5 rounded-full bg-zinc-500/15 border border-zinc-500/30 text-zinc-400">
                      Draft
                    </span>
                  </div>
                  <div className="flex items-center gap-4 text-xs text-muted-foreground mb-4">
                    <span className="font-mono text-[var(--accent-primary)] font-bold flex items-center gap-0.5">
                      <Zap className="h-3 w-3" /> {m.total_xp} XP
                    </span>
                    <span className="flex items-center gap-0.5">
                      <BookOpen className="h-3 w-3" /> {m.total_sections} Sections
                    </span>
                  </div>
                </div>

                <div className="flex items-center gap-3 mt-4 pt-4 border-t border-border/40">
                  <button
                    onClick={() => handleDelete(m.id)}
                    className="p-2 rounded-xl border border-red-500/20 hover:border-red-500/50 hover:bg-red-500/5 text-red-400 hover:text-red-300 transition-all cursor-pointer shrink-0"
                    title="Delete Draft"
                  >
                    <Trash2 className="h-4 w-4" />
                  </button>
                  <Link
                    href={`/builder/${m.id}/edit`}
                    className="flex-1 text-center py-2 rounded-xl text-xs font-bold text-white bg-[var(--accent-primary)] hover:opacity-90 transition-opacity block"
                  >
                    Continue Editing
                  </Link>
                </div>
              </div>
            ))}
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
