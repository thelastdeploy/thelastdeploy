// web/frontend/components/builder/editors/section-editor.tsx

"use client";

import { BuilderSectionInput } from "@/lib/types";
import { useEffect } from "react";
import { useEditor, EditorContent } from "@tiptap/react";
import StarterKit from "@tiptap/starter-kit";
import { Markdown } from "tiptap-markdown";
import {
  Bold,
  Italic,
  Code,
  Heading2,
  Heading3,
  List,
  ListOrdered,
  Quote,
  Terminal as TerminalIcon,
  Minus,
} from "lucide-react";

interface Props {
  section: BuilderSectionInput;
  onChange: (updated: BuilderSectionInput) => void;
}

export function SectionEditor({ section, onChange }: Props) {
  const editor = useEditor({
    extensions: [
      StarterKit.configure({ heading: { levels: [2, 3] } }),
      Markdown.configure({ html: false, linkify: true }),
    ],
    content: section.content || "",
    onUpdate: ({ editor }) => {
      const markdown = (editor.storage as any).markdown.getMarkdown();
      onChange({ ...section, content: markdown });
    },
    editorProps: {
      attributes: {
        class: "outline-none min-h-[calc(100vh-220px)]",
        spellcheck: "true",
      },
    },
  });

  // Re-initialise content when a different section is selected
  useEffect(() => {
    if (!editor) return;
    const currentMarkdown = (editor.storage as any).markdown.getMarkdown();
    if (section.content !== currentMarkdown) {
      editor.commands.setContent(section.content || "");
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [section.id]);

  const handleFieldChange = (key: keyof BuilderSectionInput, val: any) =>
    onChange({ ...section, [key]: val });

  const charCount = editor?.state.doc.textContent.length ?? 0;
  const lineCount = (section.content || "").split("\n").length;

  const toolBtn = (active: boolean, onClick: () => void, title: string, Icon: any) => (
    <button
      onClick={onClick}
      title={title}
      className={`w-7 h-7 rounded-md flex items-center justify-center transition-all cursor-pointer text-sm ${
        active
          ? "bg-[rgba(var(--accent-primary-rgb),0.12)] text-[var(--accent-primary)]"
          : "text-muted-foreground hover:text-foreground hover:bg-muted/60"
      }`}
    >
      <Icon className="h-3.5 w-3.5" />
    </button>
  );

  return (
    <div className="h-full flex flex-col bg-background">
      <style>{`
        /* Scoped TipTap prose styles */
        .tiptap-section-editor .ProseMirror { outline: none; }
        .tiptap-section-editor .ProseMirror p {
          margin: 0 0 1.1rem;
          line-height: 1.75;
          color: var(--foreground);
          font-size: 0.9rem;
        }
        .tiptap-section-editor .ProseMirror h2 {
          font-size: 1.35rem;
          font-weight: 900;
          margin: 2rem 0 0.75rem;
          color: var(--foreground);
          padding-bottom: 0.4rem;
          border-bottom: 1px solid var(--border);
        }
        .tiptap-section-editor .ProseMirror h3 {
          font-size: 1.1rem;
          font-weight: 800;
          margin: 1.5rem 0 0.5rem;
          color: var(--foreground);
        }
        .tiptap-section-editor .ProseMirror blockquote {
          border-left: 3px solid var(--accent-primary);
          padding: 0.25rem 0 0.25rem 1rem;
          color: var(--muted-foreground);
          font-style: italic;
          margin: 1.25rem 0;
          background: rgba(var(--accent-primary-rgb), 0.03);
          border-radius: 0 0.5rem 0.5rem 0;
        }
        .tiptap-section-editor .ProseMirror pre {
          background: var(--muted) !important;
          border: 1px solid var(--border);
          border-radius: 0.6rem;
          padding: 0.9rem 1rem;
          margin: 1.25rem 0;
          color: var(--foreground);
          font-family: ui-monospace, monospace;
          font-size: 0.82rem;
          overflow-x: auto;
        }
        .tiptap-section-editor .ProseMirror code:not(pre code) {
          background: rgba(var(--accent-primary-rgb), 0.08);
          color: var(--accent-primary);
          padding: 0.15rem 0.4rem;
          border-radius: 0.25rem;
          font-family: ui-monospace, monospace;
          font-size: 0.82em;
        }
        .tiptap-section-editor .ProseMirror ul,
        .tiptap-section-editor .ProseMirror ol {
          padding-left: 1.5rem;
          margin-bottom: 1rem;
          color: var(--foreground);
        }
        .tiptap-section-editor .ProseMirror ul { list-style-type: disc; }
        .tiptap-section-editor .ProseMirror ol { list-style-type: decimal; }
        .tiptap-section-editor .ProseMirror li { margin-bottom: 0.25rem; line-height: 1.7; }
        .tiptap-section-editor .ProseMirror p.is-editor-empty:first-child::before {
          content: attr(data-placeholder);
          float: left;
          color: var(--muted-foreground);
          opacity: 0.5;
          pointer-events: none;
          height: 0;
        }
      `}</style>

      {/* ── META BAR ──────────────────────────────────────────── */}
      <div className="flex items-center gap-3 px-4 py-3 border-b border-border bg-card/40 shrink-0">
        <div className="flex-1 min-w-0">
          <input
            type="text"
            value={section.title}
            onChange={(e) => handleFieldChange("title", e.target.value)}
            placeholder="Section title…"
            className="w-full bg-transparent text-lg font-black text-foreground placeholder:text-muted-foreground/50 focus:outline-none"
          />
        </div>
        <div className="flex items-center gap-1.5 shrink-0">
          <span className="text-[10px] text-muted-foreground font-bold uppercase tracking-wider">XP</span>
          <input
            type="number"
            value={section.xp}
            onChange={(e) => handleFieldChange("xp", parseInt(e.target.value) || 0)}
            className="w-16 px-2 py-1 rounded-lg border border-border bg-background text-sm text-foreground font-mono font-black text-center focus:outline-none focus:border-[var(--accent-primary)] transition-colors"
          />
        </div>
      </div>

      {/* ── TOOLBAR ───────────────────────────────────────────── */}
      <div className="flex items-center gap-0.5 px-4 py-1.5 border-b border-border bg-card/20 shrink-0 overflow-x-auto">
        {toolBtn(!!editor?.isActive("bold"), () => editor?.chain().focus().toggleBold().run(), "Bold (⌘B)", Bold)}
        {toolBtn(!!editor?.isActive("italic"), () => editor?.chain().focus().toggleItalic().run(), "Italic (⌘I)", Italic)}
        {toolBtn(!!editor?.isActive("code"), () => editor?.chain().focus().toggleCode().run(), "Inline code", Code)}
        <div className="w-px h-4 bg-border mx-1 shrink-0" />
        {toolBtn(!!editor?.isActive("heading", { level: 2 }), () => editor?.chain().focus().toggleHeading({ level: 2 }).run(), "Heading 2", Heading2)}
        {toolBtn(!!editor?.isActive("heading", { level: 3 }), () => editor?.chain().focus().toggleHeading({ level: 3 }).run(), "Heading 3", Heading3)}
        <div className="w-px h-4 bg-border mx-1 shrink-0" />
        {toolBtn(!!editor?.isActive("bulletList"), () => editor?.chain().focus().toggleBulletList().run(), "Bullet list", List)}
        {toolBtn(!!editor?.isActive("orderedList"), () => editor?.chain().focus().toggleOrderedList().run(), "Ordered list", ListOrdered)}
        {toolBtn(!!editor?.isActive("blockquote"), () => editor?.chain().focus().toggleBlockquote().run(), "Blockquote", Quote)}
        {toolBtn(!!editor?.isActive("codeBlock"), () => editor?.chain().focus().toggleCodeBlock().run(), "Code block", TerminalIcon)}
        <div className="w-px h-4 bg-border mx-1 shrink-0" />
        <button
          onClick={() => editor?.chain().focus().setHorizontalRule().run()}
          className="w-7 h-7 rounded-md flex items-center justify-center transition-all cursor-pointer text-muted-foreground hover:text-foreground hover:bg-muted/60"
          title="Divider"
        >
          <Minus className="h-3.5 w-3.5" />
        </button>
      </div>

      {/* ── EDITOR CANVAS ─────────────────────────────────────── */}
      <div className="flex-1 overflow-y-auto px-8 py-6 tiptap-section-editor">
        <EditorContent editor={editor} />
      </div>

      {/* ── STATUS BAR ────────────────────────────────────────── */}
      <div className="px-4 py-1.5 border-t border-border bg-card/20 text-[10px] text-muted-foreground font-mono flex items-center justify-between shrink-0 select-none">
        <span>Markdown • WYSIWYG</span>
        <span>{charCount} chars · {lineCount} lines</span>
      </div>
    </div>
  );
}
