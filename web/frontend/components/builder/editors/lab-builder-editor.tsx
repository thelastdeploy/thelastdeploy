// web/frontend/components/builder/editors/lab-builder-editor.tsx

"use client";

import { useState, useCallback } from "react";
import { BuilderLabInput } from "@/lib/types";
import { PremiumSelect, PremiumStepper } from "../ui-components";
import {
  Settings,
  ShieldCheck,
  RotateCcw,
  Terminal,
  Plus,
  Trash2,
  CheckCircle2,
  XCircle,
  Zap,
  Clock,
  FlaskConical,
  Copy,
  Check,
} from "lucide-react";
import CodeMirror from "@uiw/react-codemirror";
import { StreamLanguage } from "@codemirror/language";
import { shell } from "@codemirror/legacy-modes/mode/shell";
import { oneDark } from "@codemirror/theme-one-dark";
import { EditorView } from "@codemirror/view";

interface Props {
  lab: BuilderLabInput;
  onChange: (updated: BuilderLabInput) => void;
}

// ── Bash dry-run linter ────────────────────────────────────────────────────
interface LintResult {
  passed: boolean;
  issues: string[];
}

function lintBashScript(script: string, scriptName: string): LintResult {
  const issues: string[] = [];
  if (!script || !script.trim()) {
    return { passed: false, issues: [`${scriptName} is empty.`] };
  }
  const lines = script.split("\n");
  const firstLine = lines[0]?.trim();
  if (firstLine !== "#!/bin/bash" && firstLine !== "#!/usr/bin/env bash") {
    issues.push(`Missing shebang on line 1 (expected #!/bin/bash).`);
  }
  if (/\r/.test(script)) {
    issues.push("Windows line endings (\\r\\n) detected. Use Unix line endings.");
  }
  if (scriptName === "Validator script" && !/exit\s+0/.test(script)) {
    issues.push("No 'exit 0' found. Validator must have a success exit path.");
  }
  // Heuristic: unclosed single quotes
  const singleQuoteCount = (script.match(/(?<!\\)'/g) || []).length;
  if (singleQuoteCount % 2 !== 0) {
    issues.push("Possible unclosed single quote detected.");
  }
  // Heuristic: unclosed double quotes (rough)
  const doubleQuoteCount = (script.match(/(?<!\\)"/g) || []).length;
  if (doubleQuoteCount % 2 !== 0) {
    issues.push("Possible unclosed double quote detected.");
  }
  return { passed: issues.length === 0, issues };
}

// ── CodeMirror extensions (stable ref) ─────────────────────────────────────
const shellExtensions = [
  StreamLanguage.define(shell),
  EditorView.theme({
    "&": { fontSize: "13px", fontFamily: "ui-monospace, 'Cascadia Code', monospace" },
    ".cm-content": { padding: "12px 0" },
    ".cm-line": { padding: "0 16px" },
    ".cm-scroller": { overflow: "auto" },
  }),
];

// ── Step badge ──────────────────────────────────────────────────────────────
function StepBadge({ number, label, icon: Icon }: { number: number; label: string; icon: any }) {
  return (
    <div className="flex items-center gap-2.5 mb-4">
      <div className="w-6 h-6 rounded-full bg-[var(--accent-primary)] flex items-center justify-center shrink-0">
        <span className="text-[10px] font-black text-black">{number}</span>
      </div>
      <div className="flex items-center gap-1.5">
        <Icon className="h-4 w-4 text-[var(--accent-primary)]" />
        <h3 className="text-sm font-black text-foreground">{label}</h3>
      </div>
      <div className="flex-1 h-px bg-border/60" />
    </div>
  );
}

// ── Lint result display ─────────────────────────────────────────────────────
function LintResultBadge({ result }: { result: LintResult | null }) {
  if (!result) return null;
  if (result.passed) {
    return (
      <div className="flex items-center gap-1.5 text-emerald-400 text-[11px] font-bold">
        <CheckCircle2 className="h-3.5 w-3.5" />
        Dry-run passed — script looks valid
      </div>
    );
  }
  return (
    <div className="space-y-1">
      <div className="flex items-center gap-1.5 text-rose-400 text-[11px] font-bold">
        <XCircle className="h-3.5 w-3.5" />
        {result.issues.length} issue{result.issues.length > 1 ? "s" : ""} found
      </div>
      <ul className="list-disc pl-5 space-y-0.5">
        {result.issues.map((issue, i) => (
          <li key={i} className="text-[11px] text-rose-300/80 font-mono">
            {issue}
          </li>
        ))}
      </ul>
    </div>
  );
}

// ── Script editor block ─────────────────────────────────────────────────────
function ScriptEditor({
  value,
  onChange,
  placeholder,
  scriptName,
}: {
  value: string;
  onChange: (val: string) => void;
  placeholder: string;
  scriptName: string;
}) {
  const [lintResult, setLintResult] = useState<LintResult | null>(null);
  const [copied, setCopied] = useState(false);

  const handleDryRun = () => {
    setLintResult(lintBashScript(value, scriptName));
  };

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(value);
      setCopied(true);
      setTimeout(() => setCopied(false), 1500);
    } catch {}
  };

  const lineCount = value ? value.split("\n").length : 0;

  return (
    <div className="rounded-xl overflow-hidden border border-zinc-700/60 bg-zinc-950">
      {/* Script editor toolbar */}
      <div className="flex items-center justify-between px-4 py-2 bg-zinc-900/80 border-b border-zinc-800 text-[11px] text-zinc-400">
        <span className="font-mono font-bold">{scriptName.toLowerCase().replace(" ", "_")}.sh</span>
        <div className="flex items-center gap-3">
          <span className="text-zinc-600">{lineCount} lines</span>
          <button
            onClick={handleCopy}
            className="flex items-center gap-1 hover:text-zinc-200 transition-colors cursor-pointer"
            title="Copy script"
          >
            {copied ? <Check className="h-3.5 w-3.5 text-emerald-400" /> : <Copy className="h-3.5 w-3.5" />}
          </button>
          <button
            onClick={handleDryRun}
            className="flex items-center gap-1.5 px-2.5 py-1 rounded-md bg-[rgba(var(--accent-primary-rgb),0.15)] text-[var(--accent-primary)] hover:bg-[rgba(var(--accent-primary-rgb),0.25)] border border-[rgba(var(--accent-primary-rgb),0.25)] transition-all cursor-pointer font-bold text-[10px] uppercase tracking-wider"
          >
            <ShieldCheck className="h-3 w-3" /> Dry Run
          </button>
        </div>
      </div>

      {/* CodeMirror editor */}
      <div className="min-h-[200px]">
        <CodeMirror
          value={value}
          onChange={onChange}
          extensions={shellExtensions}
          theme={oneDark}
          placeholder={placeholder}
          basicSetup={{
            lineNumbers: true,
            highlightActiveLineGutter: true,
            highlightActiveLine: true,
            foldGutter: false,
            dropCursor: false,
            allowMultipleSelections: false,
            indentOnInput: true,
            bracketMatching: true,
            autocompletion: false,
            crosshairCursor: false,
          }}
          style={{ minHeight: "200px" }}
        />
      </div>

      {/* Lint result */}
      {lintResult && (
        <div className="px-4 py-2.5 bg-zinc-900/60 border-t border-zinc-800">
          <LintResultBadge result={lintResult} />
        </div>
      )}
    </div>
  );
}

// ── Main component ──────────────────────────────────────────────────────────
export function LabBuilderEditor({ lab, onChange }: Props) {
  const handleFieldChange = useCallback(
    (key: keyof BuilderLabInput, val: any) => {
      onChange({ ...lab, [key]: val });
    },
    [lab, onChange]
  );

  const handleCommandChange = (index: number, val: string) => {
    const updatedCmds = [...lab.seed_commands];
    updatedCmds[index] = val;
    handleFieldChange("seed_commands", updatedCmds);
  };

  const addCommand = () => {
    handleFieldChange("seed_commands", [...lab.seed_commands, ""]);
  };

  const deleteCommand = (index: number) => {
    handleFieldChange("seed_commands", lab.seed_commands.filter((_, i) => i !== index));
  };

  return (
    <div className="h-full flex flex-col bg-background overflow-hidden">
      {/* ── META BAR ────────────────────────────────────────────────────── */}
      <div className="flex items-center gap-3 px-6 py-3 border-b border-border bg-card/40 shrink-0">
        <FlaskConical className="h-4 w-4 text-[var(--accent-primary)] shrink-0" />
        <input
          type="text"
          value={lab.title}
          onChange={(e) => handleFieldChange("title", e.target.value)}
          placeholder="Lab title…"
          className="flex-1 bg-transparent text-base font-black text-foreground placeholder:text-muted-foreground/50 focus:outline-none min-w-0"
        />
        <span className="text-[10px] font-mono font-bold text-muted-foreground bg-muted border border-border px-2 py-0.5 rounded shrink-0">
          {lab.id}
        </span>
      </div>

      {/* ── SCROLLABLE BODY ─────────────────────────────────────────────── */}
      <div className="flex-1 overflow-y-auto min-h-0 select-text">
        <div className="max-w-3xl mx-auto px-6 py-8 space-y-10">

          {/* ══ STEP 1 — CONFIG ══════════════════════════════════════════ */}
          <section>
            <StepBadge number={1} label="Lab Configuration" icon={Settings} />

            <div className="space-y-5">
              {/* Lab ID + Title */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider block">
                    Lab ID (Slug)
                  </label>
                  <input
                    type="text"
                    value={lab.id}
                    onChange={(e) =>
                      handleFieldChange("id", e.target.value.toLowerCase().replace(/\s+/g, "-").replace(/[^a-z0-9-_]/g, ""))
                    }
                    placeholder="nginx-permanent-redirect"
                    className="w-full px-3 py-2 rounded-xl border border-border bg-background text-sm font-mono text-foreground focus:outline-none focus:border-[var(--accent-primary)] focus:ring-1 focus:ring-[var(--accent-primary)] transition-all"
                  />
                  <p className="text-[10px] text-muted-foreground/60">
                    Globally unique. Used by the CLI to identify this lab.
                  </p>
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider block">
                    Lab Title
                  </label>
                  <input
                    type="text"
                    value={lab.title}
                    onChange={(e) => handleFieldChange("title", e.target.value)}
                    placeholder="Configure Permanent Redirect"
                    className="w-full px-3 py-2 rounded-xl border border-border bg-background text-sm text-foreground focus:outline-none focus:border-[var(--accent-primary)] focus:ring-1 focus:ring-[var(--accent-primary)] transition-all"
                  />
                </div>
              </div>

              {/* XP + Duration */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <PremiumStepper
                  value={lab.xp}
                  onChange={(val) => handleFieldChange("xp", val)}
                  min={1}
                  max={500}
                  step={5}
                  label="Lab XP"
                />
                <PremiumStepper
                  value={lab.estimated_minutes ?? 10}
                  onChange={(val) => handleFieldChange("estimated_minutes", val)}
                  min={1}
                  max={120}
                  step={5}
                  label="Est. Duration (minutes)"
                />
              </div>

              {/* Setup Type */}
              <PremiumSelect
                value={lab.setup_type || "shell"}
                onChange={(val) => handleFieldChange("setup_type", val)}
                options={[
                  { value: "shell", label: "Shell (runs seed commands on student's system)" },
                  { value: "none", label: "None (no environment setup)" },
                ]}
                label="Setup Type"
                className="max-w-md"
              />

              {/* Seed Commands */}
              {lab.setup_type !== "none" && (
                <div className="space-y-3">
                  <div className="flex items-center justify-between">
                    <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider">
                      Seed Environment Commands
                    </label>
                    <button
                      onClick={addCommand}
                      className="flex items-center gap-1 px-2.5 py-1.5 rounded-lg bg-[rgba(var(--accent-primary-rgb),0.08)] border border-[rgba(var(--accent-primary-rgb),0.2)] text-[var(--accent-primary)] hover:bg-[rgba(var(--accent-primary-rgb),0.15)] transition-all cursor-pointer text-xs font-bold"
                    >
                      <Plus className="h-3.5 w-3.5" /> Add Command
                    </button>
                  </div>
                  <p className="text-[11px] text-muted-foreground/60 -mt-1">
                    These shell commands run on the student's machine before they start the lab.
                  </p>
                  {lab.seed_commands.length === 0 ? (
                    <div className="text-[11px] text-muted-foreground/50 italic border border-dashed border-border rounded-xl p-4 text-center">
                      No seed commands. Click "Add Command" to configure the lab environment.
                    </div>
                  ) : (
                    <div className="space-y-2">
                      {lab.seed_commands.map((cmd, idx) => (
                        <div key={idx} className="flex items-center gap-2">
                          <Terminal className="h-3.5 w-3.5 text-muted-foreground/50 shrink-0" />
                          <input
                            type="text"
                            value={cmd}
                            onChange={(e) => handleCommandChange(idx, e.target.value)}
                            placeholder="e.g. sudo systemctl start nginx || true"
                            className="flex-1 px-3 py-1.5 rounded-lg border border-border bg-background text-xs font-mono text-foreground focus:outline-none focus:border-[var(--accent-primary)] transition-all"
                          />
                          <button
                            onClick={() => deleteCommand(idx)}
                            className="p-1.5 rounded-lg border border-border text-muted-foreground hover:text-red-400 hover:border-red-400/30 transition-all cursor-pointer shrink-0"
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
          </section>

          {/* ══ STEP 2 — VALIDATOR SCRIPT ════════════════════════════════ */}
          <section>
            <StepBadge number={2} label="Validator Script" icon={ShieldCheck} />
            <p className="text-xs text-muted-foreground/70 mb-4 -mt-2 leading-relaxed">
              This bash script is run by the <code className="font-mono text-[var(--accent-primary)]">tld check</code> command to grade the lab.
              Exit <code className="font-mono text-[var(--accent-primary)]">0</code> = pass, non-zero = fail.{" "}
              <span className="font-bold text-amber-400">Required to publish.</span>
            </p>
            <ScriptEditor
              value={lab.validator_script}
              onChange={(val) => handleFieldChange("validator_script", val)}
              placeholder={"#!/bin/bash\n# Write checks that verify student lab tasks.\n# Return exit status 0 if passed, non-zero on failure.\n\nif grep -q 'expected_output' ~/some-file.txt; then\n  exit 0\nelse\n  exit 1\nfi"}
              scriptName="Validator script"
            />
          </section>

          {/* ══ STEP 3 — CLEANUP SCRIPT ══════════════════════════════════ */}
          <section className="pb-8">
            <StepBadge number={3} label="Cleanup Script" icon={RotateCcw} />
            <p className="text-xs text-muted-foreground/70 mb-4 -mt-2 leading-relaxed">
              Runs after lab completion (or if the student abandons the lab) to restore the environment.
              Should undo anything the seed commands or the student did.
              <span className="ml-1 text-muted-foreground/50">(Optional)</span>
            </p>
            <ScriptEditor
              value={lab.cleanup_script}
              onChange={(val) => handleFieldChange("cleanup_script", val)}
              placeholder={"#!/bin/bash\n# Restore the environment to its original state.\n# This runs after the lab is completed or abandoned.\n\n# Example: restore a config backup\n# if [ -f /etc/nginx/sites-available/default.bak ]; then\n#   sudo cp /etc/nginx/sites-available/default.bak /etc/nginx/sites-available/default\n# fi"}
              scriptName="Cleanup script"
            />
          </section>

        </div>
      </div>
    </div>
  );
}
