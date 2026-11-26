"use client";

import React from "react";
import { AlertCircle, ArrowLeft, Check, Search } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Modal, ModalBody, ModalHeader } from "@/components/shared/modal";
import type { Module } from "@/lib/types";

interface AdoptModuleModalProps {
  isOpen: boolean;
  availableModules: Module[];
  selectedModule: Module | null;
  search: string;
  customId: string;
  customTitle: string;
  loading: boolean;
  error: string | null;
  onClose: () => void;
  onSearchChange: (value: string) => void;
  onSelectModule: (mod: Module | null) => void;
  onCustomIdChange: (value: string) => void;
  onCustomTitleChange: (value: string) => void;
  onSubmit: (e: React.FormEvent) => void;
}

export function AdoptModuleModal({
  isOpen,
  availableModules,
  selectedModule,
  search,
  customId,
  customTitle,
  loading,
  error,
  onClose,
  onSearchChange,
  onSelectModule,
  onCustomIdChange,
  onCustomTitleChange,
  onSubmit,
}: AdoptModuleModalProps) {
  return (
    <Modal isOpen={isOpen} onClose={onClose} maxWidthClass="max-w-2xl" className="max-h-[85vh]">
      <ModalHeader
        title="Adopt Official Platform Module"
        description="Directly add verified TLD curriculum to this organization without modifying underlying labs."
        onClose={onClose}
      />
      <ModalBody>
        {error && (
          <div className="p-3 rounded-none bg-rose-500/10 border border-rose-500/20 text-rose-600 dark:text-rose-400 text-xs flex items-center gap-2">
            <AlertCircle className="h-4 w-4 shrink-0" />
            <span>{error}</span>
          </div>
        )}

        {!selectedModule ? (
          <>
            <div className="relative">
              <Search className="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Search official modules by title or topic..."
                value={search}
                onChange={(e) => onSearchChange(e.target.value)}
                className="pl-9 rounded-none text-xs h-9"
              />
            </div>

            <div className="space-y-2 mt-3 max-h-[400px] overflow-y-auto pr-1">
              {availableModules
                .filter(
                  (m) =>
                    m.title.toLowerCase().includes(search.toLowerCase()) ||
                    (m.topic && m.topic.toLowerCase().includes(search.toLowerCase()))
                )
                .map((mod) => (
                  <div
                    key={mod.id}
                    onClick={() => {
                      onSelectModule(mod);
                      onCustomIdChange(mod.id);
                      onCustomTitleChange(mod.title);
                    }}
                    className="p-4 rounded-none border border-border hover:border-[var(--accent-primary)]/60 bg-muted/20 hover:bg-muted/40 transition-all cursor-pointer flex items-center justify-between gap-4"
                  >
                    <div className="space-y-1">
                      <div className="flex items-center gap-2">
                        <span className="text-sm font-bold text-foreground">{mod.title}</span>
                        <span className="text-[10px] font-mono px-2 py-0.5 rounded-none border border-border bg-muted font-bold text-muted-foreground">
                          {mod.topic}
                        </span>
                      </div>
                      <p className="text-xs text-muted-foreground line-clamp-1">
                        {mod.description}
                      </p>
                      <div className="flex items-center gap-3 text-[11px] text-muted-foreground">
                        <span>{mod.total_sections} sections</span>
                        <span>•</span>
                        <span>{mod.difficulty}</span>
                        <span>•</span>
                        <span>{mod.estimated_minutes} min</span>
                      </div>
                    </div>
                    <Button
                      size="sm"
                      variant="outline"
                      className="rounded-none text-xs font-bold shrink-0 cursor-pointer"
                    >
                      Select
                    </Button>
                  </div>
                ))}

              {availableModules.length === 0 && (
                <div className="py-8 text-center text-xs text-muted-foreground">
                  All official platform modules have already been adopted into this workspace!
                </div>
              )}
            </div>
          </>
        ) : (
          <form onSubmit={onSubmit} className="space-y-4">
            <div className="p-4 rounded-none border border-border bg-muted/30 flex items-center justify-between">
              <div>
                <div className="text-xs text-muted-foreground font-mono">
                  Selected Source Module
                </div>
                <div className="text-sm font-bold text-foreground mt-0.5">
                  {selectedModule.title}
                </div>
                <div className="text-xs text-muted-foreground font-mono">
                  {selectedModule.id}
                </div>
              </div>
              <Button
                type="button"
                variant="ghost"
                size="sm"
                onClick={() => onSelectModule(null)}
                className="text-xs cursor-pointer rounded-none"
              >
                Change
              </Button>
            </div>

            <div className="space-y-3 pt-2">
              <div>
                <label className="text-xs font-bold text-foreground mb-1 block">
                  Module ID in Workspace
                </label>
                <Input
                  value={customId}
                  onChange={(e) => onCustomIdChange(e.target.value)}
                  placeholder="e.g. linux-fundamentals"
                  className="rounded-none text-xs font-mono h-9"
                  required
                />
                <p className="text-[11px] text-muted-foreground mt-1">
                  Defaults to the official ID. You can customize the identifier for this
                  workspace.
                </p>
              </div>

              <div>
                <label className="text-xs font-bold text-foreground mb-1 block">
                  Module Title in Workspace
                </label>
                <Input
                  value={customTitle}
                  onChange={(e) => onCustomTitleChange(e.target.value)}
                  placeholder="e.g. Linux Fundamentals"
                  className="rounded-none text-xs h-9"
                  required
                />
              </div>
            </div>

            <div className="pt-4 border-t border-border flex items-center justify-end gap-2.5">
              <Button
                type="button"
                variant="outline"
                onClick={() => onSelectModule(null)}
                className="rounded-none text-xs font-bold h-9 cursor-pointer gap-1.5"
              >
                <ArrowLeft className="h-3.5 w-3.5" />
                <span>Back</span>
              </Button>
              <Button
                type="submit"
                disabled={loading}
                className="rounded-none bg-[var(--accent-primary)] text-white dark:text-black hover:opacity-90 font-bold text-xs h-9 cursor-pointer gap-1.5"
              >
                <Check className="h-3.5 w-3.5" />
                <span>{loading ? "Adopting..." : "Confirm & Add to Workspace"}</span>
              </Button>
            </div>
          </form>
        )}
      </ModalBody>
    </Modal>
  );
}
