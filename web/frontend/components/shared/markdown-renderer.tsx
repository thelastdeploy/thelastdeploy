// web/frontend/components/shared/markdown-renderer.tsx
// Shared component — identical rendering to the live section-content view.
// Used by both SectionContent (module reading) and LivePreview (builder).

"use client";

import React, { useState } from "react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { Copy, Check, Info, Lightbulb, AlertCircle, AlertTriangle } from "lucide-react";

// ─── Syntax Highlighter ──────────────────────────────────────────────────────

function esc(text: string) {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

function highlightCode(code: string, language: string): React.ReactNode {
  if (!code) return "";
  const lang = language.toLowerCase();

  if (["bash", "sh", "shell"].includes(lang)) {
    const cmds = ["docker","sudo","cd","run","npm","git","apt-get","pip","python","cat","echo","mkdir","rm","ls","grep","ssh","curl","wget","chmod","chown","systemctl"];
    let result = "";
    let i = 0;
    const len = code.length;
    while (i < len) {
      if (code[i] === "#" && (i === 0 || code[i - 1] === "\n" || /\s/.test(code[i - 1]))) {
        let comment = "";
        while (i < len && code[i] !== "\n") { comment += code[i]; i++; }
        result += `<span class="text-zinc-500 font-normal">${esc(comment)}</span>`;
        continue;
      }
      if (code[i] === '"' || code[i] === "'") {
        const quote = code[i]; let str = quote; i++;
        while (i < len && code[i] !== quote) { if (code[i] === "\\") { str += code[i]; i++; } if (i < len) { str += code[i]; i++; } }
        if (i < len) { str += quote; i++; }
        result += `<span class="text-sky-300">${esc(str)}</span>`;
        continue;
      }
      if (/[a-zA-Z0-9_-]/.test(code[i])) {
        let word = "";
        while (i < len && /[a-zA-Z0-9_-]/.test(code[i])) { word += code[i]; i++; }
        if (cmds.includes(word)) result += `<span class="text-emerald-400 font-semibold">${esc(word)}</span>`;
        else if (word.startsWith("-")) result += `<span class="text-amber-400">${esc(word)}</span>`;
        else result += esc(word);
        continue;
      }
      result += esc(code[i]); i++;
    }
    return <span className="font-mono text-zinc-100" dangerouslySetInnerHTML={{ __html: result }} />;
  }

  if (["yaml", "yml"].includes(lang)) {
    let result = ""; let i = 0; const len = code.length;
    while (i < len) {
      if (code[i] === "#") {
        let comment = "";
        while (i < len && code[i] !== "\n") { comment += code[i]; i++; }
        result += `<span class="text-zinc-500">${esc(comment)}</span>`; continue;
      }
      if (code[i] === '"' || code[i] === "'") {
        const quote = code[i]; let str = quote; i++;
        while (i < len && code[i] !== quote) { if (code[i] === "\\") { str += code[i]; i++; } if (i < len) { str += code[i]; i++; } }
        if (i < len) { str += quote; i++; }
        result += `<span class="text-zinc-300">${esc(str)}</span>`; continue;
      }
      if (/[a-zA-Z0-9_-]/.test(code[i])) {
        let word = "";
        while (i < len && /[a-zA-Z0-9_-]/.test(code[i])) { word += code[i]; i++; }
        let nextIdx = i;
        while (nextIdx < len && /\s/.test(code[nextIdx]) && code[nextIdx] !== "\n") nextIdx++;
        const isKey = nextIdx < len && code[nextIdx] === ":" && (nextIdx + 1 >= len || /\s/.test(code[nextIdx + 1]));
        result += isKey ? `<span class="text-emerald-400 font-semibold">${esc(word)}</span>` : esc(word);
        continue;
      }
      result += esc(code[i]); i++;
    }
    return <span className="font-mono text-zinc-100" dangerouslySetInnerHTML={{ __html: result }} />;
  }

  if (["python", "py"].includes(lang)) {
    const keywords = ["def","class","import","from","as","return","if","else","elif","for","while","in","is","not","and","or","try","except","with","print","lambda","yield"];
    let result = ""; let i = 0; const len = code.length;
    while (i < len) {
      if (code[i] === "#") {
        let comment = "";
        while (i < len && code[i] !== "\n") { comment += code[i]; i++; }
        result += `<span class="text-zinc-500">${esc(comment)}</span>`; continue;
      }
      if (code[i] === '"' || code[i] === "'") {
        const quote = code[i]; let str = quote; i++;
        while (i < len && code[i] !== quote) { if (code[i] === "\\") { str += code[i]; i++; } if (i < len) { str += code[i]; i++; } }
        if (i < len) { str += quote; i++; }
        result += `<span class="text-emerald-300">${esc(str)}</span>`; continue;
      }
      if (/[a-zA-Z0-9_]/.test(code[i])) {
        let word = "";
        while (i < len && /[a-zA-Z0-9_]/.test(code[i])) { word += code[i]; i++; }
        result += keywords.includes(word) ? `<span class="text-purple-400 font-semibold">${esc(word)}</span>` : esc(word);
        continue;
      }
      result += esc(code[i]); i++;
    }
    return <span className="font-mono text-zinc-100" dangerouslySetInnerHTML={{ __html: result }} />;
  }

  if (lang === "json") {
    let result = ""; let i = 0; const len = code.length;
    while (i < len) {
      if (code[i] === '"') {
        let str = '"'; i++;
        while (i < len && code[i] !== '"') { if (code[i] === "\\") { str += code[i]; i++; } if (i < len) { str += code[i]; i++; } }
        if (i < len) { str += '"'; i++; }
        let nextIdx = i;
        while (nextIdx < len && /\s/.test(code[nextIdx])) nextIdx++;
        result += nextIdx < len && code[nextIdx] === ":" ? `<span class="text-emerald-400">${esc(str)}</span>` : `<span class="text-sky-300">${esc(str)}</span>`;
        continue;
      }
      if (/[a-zA-Z0-9._-]/.test(code[i])) {
        let word = "";
        while (i < len && /[a-zA-Z0-9._-]/.test(code[i])) { word += code[i]; i++; }
        result += ["true","false","null"].includes(word) || !isNaN(Number(word)) ? `<span class="text-amber-400">${esc(word)}</span>` : esc(word);
        continue;
      }
      result += esc(code[i]); i++;
    }
    return <span className="font-mono text-zinc-100" dangerouslySetInnerHTML={{ __html: result }} />;
  }

  return <span className="font-mono text-zinc-100">{code}</span>;
}

// ─── CodeBlock ────────────────────────────────────────────────────────────────

function CodeBlock({ language, value }: { language: string; value: string }) {
  const [copied, setCopied] = useState(false);
  const handleCopy = async () => {
    try { await navigator.clipboard.writeText(value); setCopied(true); setTimeout(() => setCopied(false), 2000); } catch {}
  };
  return (
    <div className="relative border border-border rounded-xl overflow-hidden bg-zinc-950 text-zinc-50 font-mono text-xs my-6 shadow-md">
      <div className="flex items-center justify-between px-4 py-2.5 bg-zinc-900 border-b border-zinc-800 text-[10px] uppercase font-bold tracking-wider text-zinc-400 select-none">
        <span>{language}</span>
        <button onClick={handleCopy} className="flex items-center gap-1.5 hover:text-zinc-200 transition-colors py-0.5 px-2 rounded hover:bg-zinc-800 cursor-pointer">
          {copied ? <><Check className="h-3 w-3 text-emerald-400" /><span className="text-emerald-400">Copied!</span></> : <><Copy className="h-3 w-3" /><span>Copy</span></>}
        </button>
      </div>
      <div className="p-4 overflow-x-auto max-h-[500px]">
        <div className="whitespace-pre text-left font-mono text-zinc-100 overflow-visible">
          {highlightCode(value, language)}
        </div>
      </div>
    </div>
  );
}

// ─── Alert Blockquote ─────────────────────────────────────────────────────────

type AlertType = "note" | "tip" | "important" | "warning" | "caution";

const AlertIcon: Record<AlertType, React.ComponentType<any>> = {
  note: Info, tip: Lightbulb, important: AlertCircle, warning: AlertTriangle, caution: AlertCircle,
};

const AlertStyles: Record<AlertType, { border: string; bg: string; text: string; title: string; label: string }> = {
  note:      { border: "border-l-4 border-blue-500 dark:border-blue-400", bg: "bg-blue-50/60 dark:bg-blue-950/15",     text: "text-blue-900 dark:text-blue-300",     title: "text-blue-800 dark:text-blue-200",     label: "Note"      },
  tip:       { border: "border-l-4 border-emerald-500",                   bg: "bg-emerald-50/60 dark:bg-emerald-950/15", text: "text-emerald-900 dark:text-emerald-300", title: "text-emerald-800 dark:text-emerald-200", label: "Tip"       },
  important: { border: "border-l-4 border-green-600",                     bg: "bg-green-50/60 dark:bg-green-950/15",   text: "text-green-900 dark:text-green-300",   title: "text-green-800 dark:text-green-200",   label: "Important" },
  warning:   { border: "border-l-4 border-amber-500",                     bg: "bg-amber-50/60 dark:bg-amber-950/15",   text: "text-amber-900 dark:text-amber-300",   title: "text-amber-800 dark:text-amber-200",   label: "Warning"   },
  caution:   { border: "border-l-4 border-red-500",                       bg: "bg-red-50/60 dark:bg-red-950/15",       text: "text-red-900 dark:text-red-300",       title: "text-red-800 dark:text-red-200",       label: "Caution"   },
};

function parseBlockquote(children: React.ReactNode): { alertType: AlertType | null; children: React.ReactNode } {
  let alertType: AlertType | null = null;
  const traverse = (node: React.ReactNode): React.ReactNode => {
    if (!node) return node;
    if (typeof node === "string") {
      const match = node.match(/^\[!(NOTE|TIP|IMPORTANT|WARNING|CAUTION)\]\s*(.*)/i);
      if (match) { alertType = match[1].toLowerCase() as AlertType; return match[2]; }
      return node;
    }
    if (Array.isArray(node)) {
      const result = [...node];
      if (result.length > 0) { const first = traverse(result[0]); if (alertType) result[0] = first; }
      return result;
    }
    if (React.isValidElement(node)) {
      const el = node as React.ReactElement<any>;
      if (el.props?.children) { const nc = traverse(el.props.children); if (alertType) return React.cloneElement(el, {}, nc); }
    }
    return node;
  };
  const newChildren = traverse(children);
  return { alertType, children: newChildren };
}

// ─── Shared Markdown Components ───────────────────────────────────────────────

const markdownComponents = {
  pre: ({ children }: any) => <div className="my-6">{children}</div>,
  code: ({ className, children, ...props }: any) => {
    const match = /language-(\w+)/.exec(className || "");
    const isInline = !match && !String(children).includes("\n");
    if (isInline) {
      return <code className="text-[var(--accent-primary)] bg-muted px-1.5 py-0.5 rounded text-xs font-mono font-semibold before:content-none after:content-none" {...props}>{children}</code>;
    }
    return <CodeBlock language={match ? match[1] : "text"} value={String(children).replace(/\n$/, "")} />;
  },
  blockquote: ({ children }: any) => {
    const { alertType, children: clean } = parseBlockquote(children);
    if (alertType) {
      const s = AlertStyles[alertType]; const Icon = AlertIcon[alertType];
      return (
        <div className={`my-6 p-4 rounded-xl ${s.border} ${s.bg} ${s.text} flex gap-3.5`}>
          <div className="shrink-0 pt-0.5"><Icon className="h-5 w-5" /></div>
          <div className="flex-1 space-y-1">
            <div className={`text-xs font-black uppercase tracking-wider ${s.title}`}>{s.label}</div>
            <div className="text-sm leading-relaxed">{clean}</div>
          </div>
        </div>
      );
    }
    return <blockquote className="border-l-4 border-border text-muted-foreground bg-muted/30 px-4 py-2 rounded-r-xl my-6 italic">{children}</blockquote>;
  },
  table: ({ children }: any) => (
    <div className="my-6 w-full overflow-x-auto border border-border rounded-xl bg-card">
      <table className="w-full text-sm border-collapse text-left m-0">{children}</table>
    </div>
  ),
  thead: ({ children }: any) => <thead className="bg-muted/50 border-b border-border text-foreground">{children}</thead>,
  tbody: ({ children }: any) => <tbody className="divide-y divide-border/60">{children}</tbody>,
  tr: ({ children }: any) => <tr className="hover:bg-muted/20 transition-colors">{children}</tr>,
  th: ({ children }: any) => <th className="px-4 py-3 text-xs font-black uppercase tracking-wider text-muted-foreground/80 border-none">{children}</th>,
  td: ({ children }: any) => <td className="px-4 py-3 text-muted-foreground leading-normal border-none">{children}</td>,
};

// ─── Public Component ─────────────────────────────────────────────────────────

interface MarkdownRendererProps {
  content: string;
  className?: string;
}

export function MarkdownRenderer({ content, className = "" }: MarkdownRendererProps) {
  return (
    <div
      className={`prose dark:prose-invert prose-sm max-w-none
        prose-headings:font-black prose-headings:text-foreground
        prose-h2:text-xl prose-h2:mt-8 prose-h2:mb-4
        prose-h3:text-base prose-h3:mt-6 prose-h3:mb-3
        prose-p:text-muted-foreground prose-p:leading-relaxed
        prose-strong:text-foreground prose-strong:font-bold
        prose-code:text-[var(--accent-primary)] prose-code:bg-muted prose-code:px-1.5 prose-code:py-0.5 prose-code:rounded prose-code:text-xs prose-code:font-mono prose-code:before:content-none prose-code:after:content-none
        prose-pre:bg-card prose-pre:border prose-pre:border-border prose-pre:rounded-xl prose-pre:p-4
        prose-blockquote:border-l-[var(--accent-primary)] prose-blockquote:text-muted-foreground prose-blockquote:not-italic
        prose-table:text-sm prose-th:text-muted-foreground prose-th:font-semibold prose-td:text-muted-foreground/95
        prose-hr:border-border prose-li:text-muted-foreground prose-a:text-[var(--accent-primary)] prose-a:no-underline hover:prose-a:underline
        ${className}`}
    >
      <ReactMarkdown remarkPlugins={[remarkGfm]} components={markdownComponents as any}>
        {content}
      </ReactMarkdown>
    </div>
  );
}
