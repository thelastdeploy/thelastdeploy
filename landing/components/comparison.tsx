"use client";

import { APP_URL } from "@/lib/constants";

interface ComparisonRow {
  title: string;
  category: string;
  traditional: {
    headline: string;
    description: string;
  };
  tld: {
    headline: string;
    description: string;
    highlight: string;
  };
}

const comparisons: ComparisonRow[] = [
  {
    category: "Execution Environment",
    title: "Where your work happens",
    traditional: {
      headline: "Synthetic Web Playgrounds",
      description: "Locked-down browser terminals with restricted privileges. You can't inspect systemd or debug kernel issues, and everything is wiped when the tab closes.",
    },
    tld: {
      headline: "Safe, Isolated Container Sandboxes",
      description: "Labs spin up in disposable Docker containers on your machine. You get the speed of native tools and real system behavior, while your host OS remains 100% untouched.",
      highlight: "Zero host pollution · Instant teardown",
    },
  },
  {
    category: "Learning Methodology",
    title: "How knowledge is built",
    traditional: {
      headline: "Passive Video Tutorials & Copy-Paste",
      description: "Follow scripted walk-throughs where the instructor never hits an unexpected error. Gives an illusion of competence that vanishes during a real production incident.",
    },
    tld: {
      headline: "Deliberately Broken Systems",
      description: "You are dropped into crashlooping pods, broken network routes, and permission conflicts. You learn by diagnosing symptoms, reading logs, and fixing the root cause.",
      highlight: "Builds real on-call intuition",
    },
  },
  {
    category: "Skill Verification",
    title: "How competence is tested",
    traditional: {
      headline: "Multiple-Choice Trivia & Bash History Regex",
      description: "Tests whether you memorized CLI flags or typed the exact command the author expected. Fails to verify whether the system actually recovered.",
    },
    tld: {
      headline: "Automated System State Assertions",
      description: "Running 'tld check' inspects active listening sockets, live container health, mounted volumes, exit codes, and process trees to prove the system is healthy.",
      highlight: "Deterministic verification with tld check",
    },
  },
  {
    category: "Cost & Ownership",
    title: "Accessibility & Pricing",
    traditional: {
      headline: "$35–$75/Month Metered Cloud Subscriptions",
      description: "Expensive monthly subscriptions that bill by the hour, pause sessions unexpectedly, and wipe all your custom configurations.",
    },
    tld: {
      headline: "100% Free Forever & Open Source",
      description: "No credit cards, zero cloud compute bills, and no vendor lock-in. Works completely on your hardware with fully inspectable open-source scenarios.",
      highlight: "Community-driven · No credit card required",
    },
  },
];

export default function Comparison() {
  return (
    <section
      id="comparison"
      className="section-divider"
      style={{ padding: "96px 24px", position: "relative", overflow: "hidden" }}
    >
      {/* Ambient background glows */}
      <div style={{
        position: "absolute",
        top: "20%",
        left: "15%",
        width: "500px",
        height: "500px",
        background: "radial-gradient(circle, rgba(239,68,68,0.03) 0%, transparent 70%)",
        pointerEvents: "none",
        filter: "blur(60px)",
      }} />
      <div style={{
        position: "absolute",
        bottom: "20%",
        right: "15%",
        width: "500px",
        height: "500px",
        background: "radial-gradient(circle, rgba(34,197,94,0.04) 0%, transparent 70%)",
        pointerEvents: "none",
        filter: "blur(60px)",
      }} />

      <div style={{ maxWidth: "1160px", margin: "0 auto", position: "relative", zIndex: 1 }}>
        {/* Section Header */}
        <div style={{ textAlign: "center", marginBottom: "64px" }}>
          <div style={{ marginBottom: "16px" }}>
            <span className="section-badge" style={{ background: "rgba(34,197,94,0.08)", borderColor: "rgba(34,197,94,0.25)", color: "#4ade80" }}>
              The Paradigm Shift
            </span>
          </div>
          <h2 style={{
            fontSize: "clamp(28px, 4vw, 48px)",
            fontWeight: 800,
            letterSpacing: "-0.03em",
            lineHeight: 1.15,
            marginBottom: "16px",
            color: "#f0f0ff",
          }}>
            A fundamentally{" "}
            <span className="text-gradient">different approach</span>
          </h2>
          <p style={{ fontSize: "17px", color: "#8888aa", maxWidth: "560px", margin: "0 auto", lineHeight: 1.6 }}>
            Traditional platforms teach syntax through passive videos. The Last Deploy builds the diagnostic muscle memory you actually need on day one.
          </p>
        </div>

        {/* Matrix Header Row */}
        <div
          className="comparison-header-row"
          style={{
            display: "grid",
            gridTemplateColumns: "1fr 1fr",
            gap: "24px",
            marginBottom: "20px",
            padding: "0 8px",
          }}
        >
          <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
            <div style={{
              width: "24px",
              height: "24px",
              borderRadius: "6px",
              background: "rgba(239,68,68,0.1)",
              border: "1px solid rgba(239,68,68,0.2)",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              color: "#f87171",
            }}>
              <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                <line x1="18" y1="6" x2="6" y2="18" />
                <line x1="6" y1="6" x2="18" y2="18" />
              </svg>
            </div>
            <span style={{ fontSize: "14px", fontWeight: 700, color: "#f87171", letterSpacing: "0.02em", textTransform: "uppercase" }}>
              Traditional Courses &amp; Sandboxes
            </span>
          </div>

          <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
            <div style={{
              width: "24px",
              height: "24px",
              borderRadius: "6px",
              background: "rgba(34,197,94,0.1)",
              border: "1px solid rgba(34,197,94,0.25)",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              color: "#4ade80",
            }}>
              <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                <polyline points="20 6 9 17 4 12" />
              </svg>
            </div>
            <span style={{ fontSize: "14px", fontWeight: 700, color: "#4ade80", letterSpacing: "0.02em", textTransform: "uppercase" }}>
              The Last Deploy
            </span>
          </div>
        </div>

        {/* Matrix Cards */}
        <div style={{ display: "flex", flexDirection: "column", gap: "16px" }}>
          {comparisons.map((row, idx) => (
            <div
              key={idx}
              className="comparison-card"
              style={{
                borderRadius: "16px",
                border: "1px solid rgba(255,255,255,0.07)",
                background: "rgba(10, 10, 18, 0.6)",
                backdropFilter: "blur(12px)",
                overflow: "hidden",
                transition: "border-color 0.25s ease, transform 0.25s ease",
              }}
            >
              {/* Pillar Category Pill */}
              <div style={{
                padding: "12px 24px",
                borderBottom: "1px solid rgba(255,255,255,0.05)",
                background: "rgba(255,255,255,0.02)",
                display: "flex",
                alignItems: "center",
                justifyContent: "space-between",
              }}>
                <span style={{ fontSize: "11px", fontWeight: 700, fontFamily: "JetBrains Mono, monospace", color: "#6a6a8a", textTransform: "uppercase", letterSpacing: "0.08em" }}>
                  {row.category}
                </span>
                <span style={{ fontSize: "12px", color: "#8888aa", fontWeight: 500 }}>
                  {row.title}
                </span>
              </div>

              {/* Two columns */}
              <div
                className="comparison-grid"
                style={{
                  display: "grid",
                  gridTemplateColumns: "1fr 1fr",
                  gap: "0",
                }}
              >
                {/* Traditional Side */}
                <div style={{
                  padding: "24px",
                  borderRight: "1px solid rgba(255,255,255,0.05)",
                  background: "rgba(239,68,68,0.015)",
                }}>
                  <div style={{ display: "flex", alignItems: "flex-start", gap: "10px", marginBottom: "8px" }}>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#f87171" strokeWidth="2.2" style={{ flexShrink: 0, marginTop: "2px" }}>
                      <circle cx="12" cy="12" r="10" />
                      <line x1="15" y1="9" x2="9" y2="15" />
                      <line x1="9" y1="9" x2="15" y2="15" />
                    </svg>
                    <h3 style={{ fontSize: "15px", fontWeight: 700, color: "#f87171", lineHeight: 1.4 }}>
                      {row.traditional.headline}
                    </h3>
                  </div>
                  <p style={{ fontSize: "13.5px", color: "#7a7a9a", lineHeight: 1.6, paddingLeft: "28px" }}>
                    {row.traditional.description}
                  </p>
                </div>

                {/* TLD Side */}
                <div style={{
                  padding: "24px",
                  background: "rgba(34,197,94,0.025)",
                }}>
                  <div style={{ display: "flex", alignItems: "flex-start", gap: "10px", marginBottom: "8px" }}>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#4ade80" strokeWidth="2.2" style={{ flexShrink: 0, marginTop: "2px" }}>
                      <circle cx="12" cy="12" r="10" />
                      <polyline points="9 12 12 15 16 10" />
                    </svg>
                    <h3 style={{ fontSize: "15px", fontWeight: 700, color: "#f0f0ff", lineHeight: 1.4 }}>
                      {row.tld.headline}
                    </h3>
                  </div>
                  <p style={{ fontSize: "13.5px", color: "#a0a0cc", lineHeight: 1.6, paddingLeft: "28px", marginBottom: "12px" }}>
                    {row.tld.description}
                  </p>
                  <div style={{ paddingLeft: "28px" }}>
                    <span style={{
                      display: "inline-flex",
                      alignItems: "center",
                      gap: "6px",
                      padding: "4px 10px",
                      borderRadius: "6px",
                      background: "rgba(34,197,94,0.1)",
                      border: "1px solid rgba(34,197,94,0.2)",
                      fontSize: "11px",
                      fontWeight: 600,
                      color: "#4ade80",
                      fontFamily: "JetBrains Mono, monospace",
                    }}>
                      <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                        <polyline points="20 6 9 17 4 12" />
                      </svg>
                      {row.tld.highlight}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Bottom CTA trigger */}
        <div style={{ marginTop: "48px", textAlign: "center" }}>
          <a
            href={`${APP_URL}/register`}
            style={{
              display: "inline-flex",
              alignItems: "center",
              gap: "8px",
              padding: "14px 32px",
              fontSize: "14px",
              fontWeight: 700,
              color: "#030a04",
              background: "linear-gradient(135deg, #22c55e 0%, #4ade80 100%)",
              borderRadius: "10px",
              textDecoration: "none",
              boxShadow: "0 0 20px rgba(34,197,94,0.3)",
              transition: "transform 0.2s ease",
            }}
            onMouseEnter={e => {
              (e.currentTarget as HTMLElement).style.transform = "translateY(-1px)";
            }}
            onMouseLeave={e => {
              (e.currentTarget as HTMLElement).style.transform = "none";
            }}
          >
            <span>Experience the Difference — Start Free</span>
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <path d="M5 12h14" />
              <path d="m12 5 7 7-7 7" />
            </svg>
          </a>
        </div>
      </div>

      <style>{`
        @media (max-width: 768px) {
          .comparison-header-row { display: none !important; }
          .comparison-grid {
            grid-template-columns: 1fr !important;
          }
          .comparison-grid > div:first-child {
            border-right: none !important;
            border-bottom: 1px solid rgba(255,255,255,0.06) !important;
          }
        }
      `}</style>
    </section>
  );
}
