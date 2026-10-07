"use client";

import { useEffect, useRef, useState } from "react";

interface MermaidDiagramProps {
  chart: string;
}

let idCounter = 0;

export default function MermaidDiagram({ chart }: MermaidDiagramProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const [svgContent, setSvgContent] = useState<string>("");
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let isMounted = true;
    const uniqueId = `mermaid-svg-${++idCounter}`;

    async function renderChart() {
      try {
        const mermaid = (await import("mermaid")).default;
        const isLight = document.documentElement.classList.contains("light");
        mermaid.initialize({
          startOnLoad: false,
          theme: isLight ? "default" : "dark",
          securityLevel: "loose",
          fontFamily: "var(--font-sans)",
        });

        const { svg } = await mermaid.render(uniqueId, chart);
        if (isMounted) {
          setSvgContent(svg);
          setError(null);
        }
      } catch (err: any) {
        if (isMounted) {
          setError(err?.message || "Failed to render diagram");
        }
      }
    }

    renderChart();

    return () => {
      isMounted = false;
    };
  }, [chart]);

  if (error) {
    return (
      <div
        className="docs-mermaid-error"
        style={{
          padding: "16px",
          margin: "20px 0",
          background: "rgba(239, 68, 68, 0.06)",
          border: "1px solid rgba(239, 68, 68, 0.2)",
          borderRadius: "8px",
        }}
      >
        <div style={{ color: "#ef4444", fontSize: "12px", fontFamily: "var(--font-mono)" }}>
          Mermaid Render Error: {error}
        </div>
        <pre style={{ fontSize: "12px", color: "var(--color-muted-foreground)", marginTop: "8px", overflowX: "auto" }}>
          {chart}
        </pre>
      </div>
    );
  }

  return (
    <div
      ref={containerRef}
      className="docs-mermaid-wrapper"
      style={{
        display: "flex",
        justifyContent: "center",
        padding: "24px 16px",
        margin: "24px 0",
        background: "var(--color-card)",
        border: "1px solid var(--color-border)",
        borderRadius: "12px",
        overflowX: "auto",
      }}
      dangerouslySetInnerHTML={{ __html: svgContent }}
    />
  );
}
