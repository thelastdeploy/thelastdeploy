"use client";

import React from "react";
import { XCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Modal, ModalBody, ModalFooter, ModalHeader } from "@/components/shared/modal";
import type { LearnerDetailAnalyticsResponse } from "@/lib/types";

interface LearnerProgressModalProps {
  isOpen: boolean;
  loading: boolean;
  detail: LearnerDetailAnalyticsResponse | null;
  onClose: () => void;
}

export function LearnerProgressModal({
  isOpen,
  loading,
  detail,
  onClose,
}: LearnerProgressModalProps) {
  return (
    <Modal isOpen={isOpen} onClose={onClose} maxWidthClass="max-w-2xl" className="max-h-[85vh]">
      <ModalHeader
        title="Learner Progress Report"
        description={
          detail ? (
            <>
              <strong>{detail.learner.username}</strong> ({detail.learner.email})
            </>
          ) : (
            "Loading learner progress..."
          )
        }
        onClose={onClose}
      />
      <ModalBody>
        {loading ? (
          <div className="py-12 text-center text-xs text-muted-foreground">
            Loading details...
          </div>
        ) : detail ? (
          <>
            <div className="grid grid-cols-4 border border-border/60 divide-x divide-border/50 text-center">
              <div className="p-2.5 bg-muted/20">
                <span className="text-[10px] text-muted-foreground uppercase font-bold">
                  Total XP
                </span>
                <p className="text-sm font-black font-mono text-[var(--accent-primary)] mt-1">
                  {detail.learner.total_xp}
                </p>
              </div>
              <div className="p-2.5 bg-muted/20">
                <span className="text-[10px] text-muted-foreground uppercase font-bold">
                  Labs Done
                </span>
                <p className="text-sm font-black font-mono mt-1">
                  {detail.learner.completed_labs_count}
                </p>
              </div>
              <div className="p-2.5 bg-muted/20">
                <span className="text-[10px] text-muted-foreground uppercase font-bold">
                  Sections Done
                </span>
                <p className="text-sm font-black font-mono mt-1">
                  {detail.learner.completed_sections_count}
                </p>
              </div>
              <div className="p-2.5 bg-muted/20">
                <span className="text-[10px] text-muted-foreground uppercase font-bold">
                  Role
                </span>
                <p className="text-sm font-black font-mono capitalize mt-1">
                  {detail.learner.role}
                </p>
              </div>
            </div>

            <div>
              <h4 className="text-xs font-bold text-foreground mb-2">Module Progress</h4>
              {detail.module_progress.length > 0 ? (
                <div className="space-y-2">
                  {detail.module_progress.map((mp) => (
                    <div
                      key={mp.module_id}
                      className="p-3 rounded-none bg-muted/20 border border-border/50 text-xs"
                    >
                      <div className="flex justify-between items-center mb-1">
                        <span className="font-bold text-foreground">{mp.title}</span>
                        <span className="font-mono text-[var(--accent-primary)] font-bold">
                          {mp.percent_complete}%
                        </span>
                      </div>
                      <div className="w-full bg-muted/50 rounded-none h-1.5 overflow-hidden">
                        <div
                          className="bg-[var(--accent-primary)] h-1.5 rounded-none transition-all"
                          style={{ width: `${mp.percent_complete}%` }}
                        />
                      </div>
                      <div className="flex justify-between text-[10px] text-muted-foreground font-mono mt-1">
                        <span>
                          Labs: {mp.completed_labs} / {mp.total_labs}
                        </span>
                        <span>
                          Sections: {mp.completed_sections} / {mp.total_sections}
                        </span>
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <p className="text-xs text-muted-foreground py-2">
                  No module progress started yet.
                </p>
              )}
            </div>

            <div>
              <h4 className="text-xs font-bold text-foreground mb-2">Completed Labs</h4>
              {detail.completed_labs.length > 0 ? (
                <div className="space-y-1.5 max-h-48 overflow-y-auto pr-1">
                  {detail.completed_labs.map((cl) => (
                    <div
                      key={cl.lab_id + cl.completed_at}
                      className="flex items-center justify-between py-1.5 px-2.5 rounded-none border border-border/40 bg-muted/20 text-xs"
                    >
                      <div>
                        <p className="font-bold text-foreground">{cl.title}</p>
                        {cl.module_title && (
                          <span className="text-[10px] text-muted-foreground">
                            {cl.module_title}
                          </span>
                        )}
                      </div>
                      <div className="text-right">
                        <span className="font-mono text-emerald-500 font-bold">
                          +{cl.xp_awarded} XP
                        </span>
                        <p className="text-[10px] text-muted-foreground font-mono">
                          {new Date(cl.completed_at).toLocaleDateString()}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <p className="text-xs text-muted-foreground py-2">No labs completed yet.</p>
              )}
            </div>
          </>
        ) : null}
      </ModalBody>
      <ModalFooter>
        <Button
          variant="outline"
          size="sm"
          onClick={onClose}
          className="rounded-none text-xs font-semibold cursor-pointer gap-1.5"
        >
          <XCircle className="h-3.5 w-3.5" />
          <span>Close</span>
        </Button>
      </ModalFooter>
    </Modal>
  );
}
