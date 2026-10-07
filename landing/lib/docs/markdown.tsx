import React from "react";
import CodeBlock from "@/components/docs/code-block";
import Callout from "@/components/docs/callout";
import Collapsible from "@/components/docs/collapsible";
import StepList from "@/components/docs/step-list";
import LabCard from "@/components/docs/lab-card";
import Badge from "@/components/docs/badge";
import MermaidDiagram from "@/components/docs/mermaid-diagram";
import { slugifyHeading } from "./toc";

function renderInline(text: string): React.ReactNode[] {
  const parts = text.split(/(\*\*[^*]+\*\*|`[^`]+`|\[[^\]]+\]\([^)]+\))/g);
  return parts.map((part, i) => {
    if (part.startsWith("**") && part.endsWith("**")) {
      return <strong key={i}>{part.slice(2, -2)}</strong>;
    }
    if (part.startsWith("`") && part.endsWith("`")) {
      return <code key={i}>{part.slice(1, -1)}</code>;
    }
    const linkMatch = part.match(/^\[([^\]]+)\]\(([^)]+)\)$/);
    if (linkMatch) {
      return (
        <a key={i} href={linkMatch[2]}>
          {linkMatch[1]}
        </a>
      );
    }
    return part;
  });
}

export function renderMarkdown(markdown: string): React.ReactNode {
  const lines = markdown.split("\n");
  const elements: React.ReactNode[] = [];

  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    const trimmed = line.trim();

    if (!trimmed) {
      i++;
      continue;
    }

    // Code Blocks ```lang
    if (trimmed.startsWith("```")) {
      const lang = trimmed.slice(3).trim() || "bash";
      const codeLines: string[] = [];
      i++;
      while (i < lines.length && !lines[i].trim().startsWith("```")) {
        codeLines.push(lines[i]);
        i++;
      }
      i++; // Skip closing ```
      if (lang === "mermaid") {
        elements.push(<MermaidDiagram key={elements.length} chart={codeLines.join("\n")} />);
      } else {
        elements.push(<CodeBlock key={elements.length} lang={lang} code={codeLines.join("\n")} />);
      }
      continue;
    }

    // Headings
    if (trimmed.startsWith("# ")) {
      const text = trimmed.slice(2).trim();
      elements.push(<h1 key={elements.length}>{renderInline(text)}</h1>);
      i++;
      continue;
    }
    if (trimmed.startsWith("## ")) {
      const text = trimmed.slice(3).trim();
      const id = slugifyHeading(text);
      elements.push(
        <h2 key={elements.length} id={id}>
          {renderInline(text)}
        </h2>
      );
      i++;
      continue;
    }
    if (trimmed.startsWith("### ")) {
      const text = trimmed.slice(4).trim();
      const id = slugifyHeading(text);
      elements.push(
        <h3 key={elements.length} id={id}>
          {renderInline(text)}
        </h3>
      );
      i++;
      continue;
    }
    if (trimmed.startsWith("#### ")) {
      const text = trimmed.slice(5).trim();
      elements.push(<h4 key={elements.length}>{renderInline(text)}</h4>);
      i++;
      continue;
    }

    // Callout Tag <Callout variant="..." title="...">text</Callout> or directive
    if (trimmed.startsWith("<Callout")) {
      const variantMatch = trimmed.match(/variant=["']([^"']+)["']/);
      const titleMatch = trimmed.match(/title=["']([^"']+)["']/);
      const textMatch = trimmed.match(/text=["']([^"']+)["']/);

      const variant = (variantMatch ? variantMatch[1] : "info") as "info" | "warning" | "danger" | "tip";
      const title = titleMatch ? titleMatch[1] : "";
      let text = textMatch ? textMatch[1] : "";

      if (!text && !trimmed.endsWith("/>")) {
        // Collect text inside tag if multiline
        const textLines: string[] = [];
        const inlineStart = trimmed.indexOf(">") + 1;
        if (inlineStart > 0 && !trimmed.endsWith("</Callout>")) {
          textLines.push(trimmed.slice(inlineStart));
        }
        i++;
        while (i < lines.length && !lines[i].includes("</Callout>")) {
          textLines.push(lines[i]);
          i++;
        }
        text = textLines.join(" ").replace("</Callout>", "").trim();
      } else if (trimmed.includes("</Callout>")) {
        const start = trimmed.indexOf(">") + 1;
        const end = trimmed.indexOf("</Callout>");
        text = trimmed.slice(start, end).trim();
      }

      elements.push(<Callout key={elements.length} variant={variant} title={title} text={text} />);
      i++;
      continue;
    }

    // StepList Tag <Steps> ... </Steps>
    if (trimmed.startsWith("<Steps>")) {
      const steps: { title: string; description: string; code?: string }[] = [];
      i++;
      while (i < lines.length && !lines[i].trim().startsWith("</Steps>")) {
        const stepLine = lines[i].trim();
        if (stepLine.startsWith("<Step")) {
          const tMatch = stepLine.match(/title=["']([^"']+)["']/);
          const cMatch = stepLine.match(/code=["']([^"']+)["']/);
          const title = tMatch ? tMatch[1] : "Step";
          const code = cMatch ? cMatch[1] : undefined;
          let desc = "";

          if (stepLine.includes("</Step>")) {
            const start = stepLine.indexOf(">") + 1;
            const end = stepLine.indexOf("</Step>");
            desc = stepLine.slice(start, end).trim();
          } else {
            i++;
            const descLines: string[] = [];
            while (i < lines.length && !lines[i].trim().startsWith("</Step>")) {
              descLines.push(lines[i].trim());
              i++;
            }
            desc = descLines.join(" ");
          }
          steps.push({ title, description: desc, code });
        }
        i++;
      }
      elements.push(<StepList key={elements.length} steps={steps} />);
      i++;
      continue;
    }

    // Collapsible Tag <Collapsible trigger="...">content</Collapsible>
    if (trimmed.startsWith("<Collapsible")) {
      const trigMatch = trimmed.match(/trigger=["']([^"']+)["']/);
      const trigger = trigMatch ? trigMatch[1] : "Click to expand";
      let content = "";
      let code: string | undefined = undefined;

      const codeMatch = trimmed.match(/code=["']([^"']+)["']/);
      if (codeMatch) code = codeMatch[1];

      i++;
      const contentLines: string[] = [];
      while (i < lines.length && !lines[i].trim().startsWith("</Collapsible>")) {
        contentLines.push(lines[i]);
        i++;
      }
      content = contentLines.join("\n").trim();

      elements.push(
        <Collapsible key={elements.length} trigger={trigger}>
          <p style={{ margin: 0, fontSize: "14px", color: "#8888aa", lineHeight: 1.6 }}>{renderInline(content)}</p>
          {code && <CodeBlock lang="bash" code={code} />}
        </Collapsible>
      );
      i++;
      continue;
    }

    // Table markdown
    if (trimmed.startsWith("|")) {
      const tableRows: string[][] = [];
      while (i < lines.length && lines[i].trim().startsWith("|")) {
        const rowLine = lines[i].trim();
        if (!rowLine.includes("---")) {
          const cells = rowLine
            .split("|")
            .slice(1, -1)
            .map((c) => c.trim());
          tableRows.push(cells);
        }
        i++;
      }
      if (tableRows.length > 0) {
        const headers = tableRows[0];
        const bodyRows = tableRows.slice(1);
        elements.push(
          <div key={elements.length} style={{ overflowX: "auto" }}>
            <table>
              <thead>
                <tr>
                  {headers.map((h, j) => (
                    <th key={j}>{renderInline(h)}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {bodyRows.map((row, j) => (
                  <tr key={j}>
                    {row.map((cell, k) => (
                      <td key={k}>{renderInline(cell)}</td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        );
      }
      continue;
    }

    // Bullet list
    if (trimmed.startsWith("- ") || trimmed.startsWith("* ")) {
      const listItems: string[] = [];
      while (i < lines.length && (lines[i].trim().startsWith("- ") || lines[i].trim().startsWith("* "))) {
        listItems.push(lines[i].trim().slice(2));
        i++;
      }
      elements.push(
        <ul key={elements.length}>
          {listItems.map((item, j) => (
            <li key={j}>{renderInline(item)}</li>
          ))}
        </ul>
      );
      continue;
    }

    // Blockquote
    if (trimmed.startsWith("> ")) {
      const quoteLines: string[] = [];
      while (i < lines.length && lines[i].trim().startsWith("> ")) {
        quoteLines.push(lines[i].trim().slice(2));
        i++;
      }
      elements.push(<blockquote key={elements.length}>{renderInline(quoteLines.join(" "))}</blockquote>);
      continue;
    }

    // Divider
    if (trimmed === "---" || trimmed === "***") {
      elements.push(<hr key={elements.length} />);
      i++;
      continue;
    }

    // Paragraph
    elements.push(<p key={elements.length}>{renderInline(line)}</p>);
    i++;
  }

  return <div className="docs-prose">{elements}</div>;
}
