"use client";

import { useEffect, useRef, useState } from "react";
import CodeBlock from "./code-block";

interface MermaidDiagramProps {
  chart: string;
}

let idCounter = 0;

export default function MermaidDiagram({ chart }: MermaidDiagramProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const [svgContent, setSvgContent] = useState<string>("");
  const [error, setError] = useState<boolean>(false);

  useEffect(() => {
    let isMounted = true;
    const uniqueId = `mermaid-svg-${++idCounter}`;

    async function renderChart() {
      try {
        const mermaid = (await import("mermaid")).default;
        const isLight = document.documentElement.classList.contains("light");

        mermaid.initialize({
          startOnLoad: false,
          theme: isLight ? "neutral" : "dark",
          securityLevel: "loose",
          fontFamily: "var(--font-sans)",
          themeVariables: isLight
            ? {
                primaryColor: "#f8fafc",
                primaryTextColor: "#0f172a",
                primaryBorderColor: "#cbd5e1",
                lineColor: "#475569",
                secondaryColor: "#ffffff",
                tertiaryColor: "#f1f5f9",
                clusterBkg: "rgba(248, 250, 252, 0.7)",
                clusterBorder: "#cbd5e1",
                edgeLabelBackground: "#ffffff",
              }
            : {
                primaryColor: "#13132a",
                primaryTextColor: "#f0f0ff",
                primaryBorderColor: "#2a2a4a",
                lineColor: "#22c55e",
                secondaryColor: "#1a1a2e",
                tertiaryColor: "#0d0d1f",
                clusterBkg: "rgba(13, 13, 31, 0.7)",
                clusterBorder: "#1e1e38",
                edgeLabelBackground: "#0d0d1f",
              },
        });

        const { svg } = await mermaid.render(uniqueId, chart.trim());
        if (isMounted) {
          setSvgContent(svg);
          setError(false);
        }
      } catch (err: any) {
        if (isMounted) {
          setError(true);
        }
      }
    }

    renderChart();

    return () => {
      isMounted = false;
    };
  }, [chart]);

  if (error) {
    return <CodeBlock lang="mermaid" code={chart} />;
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
        boxShadow: "0 4px 20px rgba(0,0,0,0.06)",
      }}
      dangerouslySetInnerHTML={{ __html: svgContent }}
    />
  );
}
