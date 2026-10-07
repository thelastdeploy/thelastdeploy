"use client";

import { useState } from "react";

interface CodeBlockProps {
  lang: string;
  code: string;
}

function highlightTokenLine(line: string, lang: string): React.ReactNode {
  const trimmed = line.trim();

  // Comments
  if (trimmed.startsWith("#") || trimmed.startsWith("//")) {
    return <span className="token-comment">{line}</span>;
  }

  // HTTP Method lines
  if (/^(GET|POST|PUT|DELETE|PATCH|HEAD|OPTIONS)\s+/.test(trimmed)) {
    const spaceIdx = line.search(/\s/);
    const method = line.slice(0, spaceIdx);
    const rest = line.slice(spaceIdx);
    return (
      <>
        <span className="token-keyword">{method}</span>
        <span className="token-string">{rest}</span>
      </>
    );
  }

  // YAML / JSON key-value pairs
  if (lang === "yaml" || lang === "json" || lang === "yml") {
    const colonIdx = line.indexOf(":");
    if (colonIdx > 0 && !line.trim().startsWith("#")) {
      const keyPart = line.slice(0, colonIdx + 1);
      const valPart = line.slice(colonIdx + 1);

      return (
        <>
          <span className="token-key">{keyPart}</span>
          <span className="token-value">{valPart}</span>
        </>
      );
    }
  }

  // Bash / Shell prompt and command syntax highlighting
  if (lang === "bash" || lang === "sh" || lang === "zsh" || lang === "terminal" || lang === "text") {
    let content = line;
    let hasPrompt = false;

    if (line.startsWith("$ ")) {
      hasPrompt = true;
      content = line.slice(2);
    }

    const tokens = content.split(" ");
    const highlighted = tokens.map((token, idx) => {
      if (idx === 0 && token.length > 0) {
        return (
          <span key={idx} className="token-keyword">
            {token}{" "}
          </span>
        );
      }
      if (token.startsWith("-")) {
        return (
          <span key={idx} className="token-flag">
            {token}{" "}
          </span>
        );
      }
      if (token.startsWith('"') || token.startsWith("'") || token.includes('="') || token.includes("='")) {
        return (
          <span key={idx} className="token-string">
            {token}{" "}
          </span>
        );
      }
      if (token.startsWith("$")) {
        return (
          <span key={idx} className="token-value">
            {token}{" "}
          </span>
        );
      }
      return token + " ";
    });

    return (
      <>
        {hasPrompt && <span className="token-prompt">$ </span>}
        {highlighted}
      </>
    );
  }

  // Dockerfile keywords
  if (lang === "dockerfile" || lang === "docker") {
    const words = line.split(" ");
    const first = words[0];
    const rest = words.slice(1).join(" ");
    if (["FROM", "RUN", "COPY", "ADD", "WORKDIR", "EXPOSE", "ENV", "ENTRYPOINT", "CMD", "USER", "ARG"].includes(first)) {
      return (
        <>
          <span className="token-keyword">{first} </span>
          <span className="token-value">{rest}</span>
        </>
      );
    }
  }

  return line || "\u00a0";
}

export default function CodeBlock({ lang, code }: CodeBlockProps) {
  const [copied, setCopied] = useState(false);

  const handleCopy = () => {
    const cleanCode = code
      .split("\n")
      .map((line) => (line.startsWith("$ ") ? line.slice(2) : line))
      .join("\n")
      .trim();
    navigator.clipboard.writeText(cleanCode || code);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="docs-code-block">
      <div className="docs-code-header">
        <span className="docs-code-lang">{lang}</span>
        <button
          className={`docs-code-copy${copied ? " copied" : ""}`}
          onClick={handleCopy}
          type="button"
        >
          {copied ? "Copied!" : "Copy"}
        </button>
      </div>
      <div className="docs-code-content">
        {code.split("\n").map((line, i) => (
          <div key={i}>{highlightTokenLine(line, lang.toLowerCase())}</div>
        ))}
      </div>
    </div>
  );
}
