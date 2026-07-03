// web/frontend/components/builder/editors/lab-editor.tsx

"use client";

import { useState } from "react";
import { BuilderLabInput } from "@/lib/types";
import { Trash2, Plus, Terminal, PlayCircle, Settings, ShieldCheck } from "lucide-react";

interface Props {
  lab: BuilderLabInput;
  onChange: (updated: BuilderLabInput) => void;
}

export function LabEditor({ lab, onChange }: Props) {
  const [activeTab, setActiveTab] = useState<"config" | "validator">("config");

  const handleFieldChange = (key: keyof BuilderLabInput, val: any) => {
    onChange({ ...lab, [key]: val });
  };

  const handleCommandChange = (index: number, val: string) => {
    const updatedCmds = [...lab.seed_commands];
    updatedCmds[index] = val;
    handleFieldChange("seed_commands", updatedCmds);
  };

  const addCommand = () => {
    handleFieldChange("seed_commands", [...lab.seed_commands, ""]);
  };

  const deleteCommand = (index: number) => {
    const updatedCmds = lab.seed_commands.filter((_, i) => i !== index);
    handleFieldChange("seed_commands", updatedCmds);
  };

  return (
    <div className="h-full flex flex-col bg-background">
      {/* Sub-tabs header */}
      <div className="px-6 border-b border-border bg-card/25 flex items-center justify-between gap-4 shrink-0">
        <div className="flex gap-4">
          <button
            onClick={() => setActiveTab("config")}
            className={`py-4 text-sm font-bold border-b-2 transition-all flex items-center gap-1.5 cursor-pointer ${
              activeTab === "config"
                ? "border-[var(--accent-primary)] text-foreground"
                : "border-transparent text-muted-foreground hover:text-foreground"
            }`}
          >
            <Settings className="h-4 w-4" /> Lab Config
          </button>
          <button
            onClick={() => setActiveTab("validator")}
            className={`py-4 text-sm font-bold border-b-2 transition-all flex items-center gap-1.5 cursor-pointer ${
              activeTab === "validator"
                ? "border-[var(--accent-primary)] text-foreground"
                : "border-transparent text-muted-foreground hover:text-foreground"
            }`}
          >
            <PlayCircle className="h-4 w-4" /> Validator Script
          </button>
        </div>

        <div className="flex items-center gap-2">
          <span className="text-[10px] font-mono font-bold text-muted-foreground bg-muted border border-border px-2 py-0.5 rounded">
            {lab.id}
          </span>
        </div>
      </div>

      {/* Editor Content Area */}
      <div className="flex-1 overflow-y-auto min-h-0 bg-background/50">
        {activeTab === "config" ? (
          <div className="p-6 max-w-xl mx-auto space-y-6">
            <div>
              <h3 className="font-black text-lg text-foreground">Configure Lab Parameters</h3>
              <p className="text-xs text-muted-foreground mt-1">Specify title, XP weights, and baseline seed environment.</p>
            </div>

            <div className="space-y-4">
              {/* ID & Title */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider block">
                    Lab ID (Slug)
                  </label>
                  <input
                    type="text"
                    value={lab.id}
                    onChange={(e) => handleFieldChange("id", e.target.value.toLowerCase().replace(/\s+/g, "-"))}
                    placeholder="dkr-connect-containers"
                    className="w-full px-3 py-2 rounded-xl border border-border bg-background text-sm font-mono text-foreground focus:outline-none focus:border-[var(--accent-primary)] focus:ring-1 focus:ring-[var(--accent-primary)] transition-all"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider block">
                    Lab Title
                  </label>
                  <input
                    type="text"
                    value={lab.title}
                    onChange={(e) => handleFieldChange("title", e.target.value)}
                    placeholder="Connect Two Containers"
                    className="w-full px-3 py-2 rounded-xl border border-border bg-background text-sm text-foreground focus:outline-none focus:border-[var(--accent-primary)] focus:ring-1 focus:ring-[var(--accent-primary)] transition-all"
                  />
                </div>
              </div>

              {/* XP & Duration */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider block">
                    Lab XP
                  </label>
                  <input
                    type="number"
                    value={lab.xp}
                    onChange={(e) => handleFieldChange("xp", parseInt(e.target.value) || 0)}
                    placeholder="30"
                    className="w-full px-3 py-2 rounded-xl border border-border bg-background text-sm text-foreground focus:outline-none focus:border-[var(--accent-primary)] focus:ring-1 focus:ring-[var(--accent-primary)] transition-all"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider block">
                    Est. Duration (Minutes)
                  </label>
                  <input
                    type="number"
                    value={lab.estimated_minutes || ""}
                    onChange={(e) => handleFieldChange("estimated_minutes", parseInt(e.target.value) || null)}
                    placeholder="10"
                    className="w-full px-3 py-2 rounded-xl border border-border bg-background text-sm text-foreground focus:outline-none focus:border-[var(--accent-primary)] focus:ring-1 focus:ring-[var(--accent-primary)] transition-all"
                  />
                </div>
              </div>

              {/* Setup Type */}
              <div className="space-y-1.5">
                <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider block">
                  Setup Type
                </label>
                <select
                  value={lab.setup_type || "shell"}
                  onChange={(e) => handleFieldChange("setup_type", e.target.value)}
                  className="w-full px-3 py-2 rounded-xl border border-border bg-background text-sm text-foreground focus:outline-none focus:border-[var(--accent-primary)] focus:ring-1 focus:ring-[var(--accent-primary)] transition-all cursor-pointer"
                >
                  <option value="shell">Shell (Local Environment commands)</option>
                  <option value="none">None</option>
                </select>
              </div>

              {/* Seed Commands */}
              {lab.setup_type !== "none" && (
                <div className="space-y-3 pt-2">
                  <div className="flex items-center justify-between">
                    <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider">
                      Seed Environment Commands
                    </label>
                    <button
                      onClick={addCommand}
                      className="p-1 rounded bg-[rgba(var(--accent-primary-rgb),0.1)] border border-[rgba(var(--accent-primary-rgb),0.2)] text-[var(--accent-primary)] hover:bg-[rgba(var(--accent-primary-rgb),0.18)] transition-all cursor-pointer"
                    >
                      <Plus className="h-3.5 w-3.5" />
                    </button>
                  </div>
                  {lab.seed_commands.length === 0 ? (
                    <p className="text-xs text-muted-foreground italic border border-dashed border-border rounded-xl p-4 text-center">
                      No seed commands. Command environment will be blank. Click '+' to add setup scripts.
                    </p>
                  ) : (
                    <div className="space-y-2">
                      {lab.seed_commands.map((cmd, idx) => (
                        <div key={idx} className="flex items-center gap-2">
                          <Terminal className="h-3.5 w-3.5 text-muted-foreground/60 shrink-0" />
                          <input
                            type="text"
                            value={cmd}
                            onChange={(e) => handleCommandChange(idx, e.target.value)}
                            placeholder="e.g. docker network create lab-net"
                            className="flex-1 px-3 py-1.5 rounded-lg border border-border bg-background text-xs font-mono text-foreground focus:outline-none focus:border-[var(--accent-primary)] transition-all"
                          />
                          <button
                            onClick={() => deleteCommand(idx)}
                            className="p-1.5 rounded-lg border border-border text-muted-foreground hover:text-red-400 hover:border-red-400/20 transition-all cursor-pointer shrink-0"
                          >
                            <Trash2 className="h-3.5 w-3.5" />
                          </button>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              )}
            </div>
          </div>
        ) : (
          <div className="h-full flex flex-col bg-zinc-950 font-mono text-sm relative">
            <div className="p-4 bg-zinc-900 border-b border-zinc-800 text-xs text-zinc-400 flex items-center justify-between shrink-0">
              <span className="flex items-center gap-1.5"><ShieldCheck className="h-4 w-4 text-emerald-400" /> validator.sh</span>
              <span>Bash shell validation script</span>
            </div>
            
            <textarea
              value={lab.validator_script || ""}
              onChange={(e) => handleFieldChange("validator_script", e.target.value)}
              placeholder="#!/bin/bash&#10;# Write checks that verify student lab tasks.&#10;# Return exit status 0 if passed, non-zero on failure.&#10;&#10;# e.g. check if file is created with target output&#10;if grep -q 'Welcome' ~/docker-test/fetched_page.txt; then&#10;  exit 0&#10;else&#10;  exit 1&#10;fi"
              className="flex-1 p-4 bg-transparent text-zinc-100 border-none outline-none focus:ring-0 focus:outline-none resize-none leading-6 font-mono text-sm overflow-y-auto"
            />
          </div>
        )}
      </div>
    </div>
  );
}
