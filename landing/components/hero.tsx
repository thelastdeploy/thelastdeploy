"use client";

import { SOCIAL_LINKS, DOCS_URL, APP_URL } from "@/lib/constants";

export default function Hero() {
  return (
    <section
      style={{
        position: "relative",
        minHeight: "100vh",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        padding: "130px 24px 80px",
        overflow: "hidden",
      }}
    >
      {/* ── Background layers ──────────────────── */}

      {/* Deep space grid */}
      <div style={{
        position: "absolute",
        inset: 0,
        backgroundImage: `
          linear-gradient(rgba(34,197,94,0.04) 1px, transparent 1px),
          linear-gradient(90deg, rgba(34,197,94,0.04) 1px, transparent 1px)
        `,
        backgroundSize: "60px 60px",
        maskImage: "radial-gradient(ellipse 80% 60% at 50% 0%, black 60%, transparent 110%)",
        WebkitMaskImage: "radial-gradient(ellipse 80% 60% at 50% 0%, black 60%, transparent 110%)",
      }} />

      {/* Primary glow orb */}
      <div
        className="animate-float-slow"
        style={{
          position: "absolute",
          top: "10%",
          left: "50%",
          transform: "translateX(-50%)",
          width: "600px",
          height: "600px",
          borderRadius: "50%",
          background: "radial-gradient(circle, rgba(34,197,94,0.12) 0%, rgba(34,197,94,0.03) 50%, transparent 70%)",
          filter: "blur(40px)",
          pointerEvents: "none",
        }}
      />

      {/* Secondary purple orb */}
      <div
        className="animate-float"
        style={{
          position: "absolute",
          top: "30%",
          right: "10%",
          width: "300px",
          height: "300px",
          borderRadius: "50%",
          background: "radial-gradient(circle, rgba(168,85,247,0.08) 0%, transparent 70%)",
          filter: "blur(30px)",
          pointerEvents: "none",
          animationDelay: "2s",
        }}
      />

      {/* Tertiary cyan orb */}
      <div
        className="animate-float"
        style={{
          position: "absolute",
          top: "20%",
          left: "5%",
          width: "250px",
          height: "250px",
          borderRadius: "50%",
          background: "radial-gradient(circle, rgba(6,182,212,0.06) 0%, transparent 70%)",
          filter: "blur(25px)",
          pointerEvents: "none",
          animationDelay: "4s",
        }}
      />

      {/* ── Content ──────────────────────────────── */}
      <div
        style={{
          position: "relative",
          zIndex: 10,
          maxWidth: "920px",
          textAlign: "center",
          width: "100%",
        }}
      >
        {/* Trust Badge */}
        <div className="animate-fade-in-up" style={{ marginBottom: "24px" }}>
          <span className="section-badge animate-pulse-glow" style={{ background: "rgba(34,197,94,0.08)", borderColor: "rgba(34,197,94,0.25)", color: "#4ade80" }}>
            <span style={{
              width: "6px",
              height: "6px",
              borderRadius: "50%",
              background: "#22c55e",
              display: "inline-block",
              boxShadow: "0 0 6px rgba(34,197,94,0.8)",
            }} />
            Free &amp; Open Source DevOps Practice Platform
          </span>
        </div>

        {/* Headline */}
        <h1
          className="animate-fade-in-up-1"
          style={{
            fontSize: "clamp(40px, 7vw, 84px)",
            fontWeight: 800,
            letterSpacing: "-0.04em",
            lineHeight: 1.05,
            marginBottom: "24px",
          }}
        >
          Learn DevOps by
          <br />
          <span className="text-gradient">fixing real systems</span>
          <span style={{ color: "#22c55e" }}>.</span>
        </h1>

        {/* Sub-headline */}
        <p
          className="animate-fade-in-up-2"
          style={{
            fontSize: "clamp(16px, 2vw, 20px)",
            color: "var(--color-landing-subtext, #8888aa)",
            lineHeight: 1.65,
            maxWidth: "680px",
            margin: "0 auto 36px",
            fontWeight: 400,
          }}
        >
          Stop copy-pasting tutorials. Read the concepts online, debug real broken Docker and Kubernetes environments in safe, isolated sandboxes, and build the muscle memory to solve production incidents.
        </p>

        {/* Action CTAs */}
        <div
          className="animate-fade-in-up-3"
          style={{
            display: "flex",
            flexDirection: "row",
            flexWrap: "wrap",
            alignItems: "center",
            justifyContent: "center",
            gap: "14px",
            marginBottom: "16px",
          }}
        >
          {/* Primary CTA */}
          <a
            href={`${APP_URL}/register`}
            style={{
              display: "inline-flex",
              alignItems: "center",
              justifyContent: "center",
              gap: "8px",
              padding: "16px 36px",
              fontSize: "16px",
              fontWeight: 700,
              color: "#030a04",
              background: "linear-gradient(135deg, #22c55e 0%, #4ade80 100%)",
              borderRadius: "12px",
              textDecoration: "none",
              boxShadow: "0 0 24px rgba(34,197,94,0.35)",
              transition: "transform 0.2s ease, box-shadow 0.2s ease",
            }}
            onMouseEnter={e => {
              (e.currentTarget as HTMLElement).style.transform = "translateY(-2px) scale(1.02)";
              (e.currentTarget as HTMLElement).style.boxShadow = "0 0 32px rgba(34,197,94,0.5)";
            }}
            onMouseLeave={e => {
              (e.currentTarget as HTMLElement).style.transform = "none";
              (e.currentTarget as HTMLElement).style.boxShadow = "0 0 24px rgba(34,197,94,0.35)";
            }}
          >
            <span>Start Practicing Free</span>
            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <path d="M5 12h14" />
              <path d="m12 5 7 7-7 7" />
            </svg>
          </a>

          {/* Secondary CTA — Install CLI */}
          <a
            href="#install"
            style={{
              display: "inline-flex",
              alignItems: "center",
              justifyContent: "center",
              gap: "8px",
              padding: "16px 28px",
              fontSize: "15px",
              fontWeight: 600,
              color: "var(--color-landing-btn-secondary-text, #f0f0ff)",
              background: "var(--color-landing-btn-secondary-bg, rgba(255,255,255,0.05))",
              borderRadius: "12px",
              textDecoration: "none",
              border: "1px solid var(--color-landing-btn-secondary-border, rgba(255,255,255,0.12))",
              backdropFilter: "blur(10px)",
              transition: "all 0.2s ease",
            }}
            onMouseEnter={e => {
              (e.currentTarget as HTMLElement).style.borderColor = "var(--color-primary)";
              (e.currentTarget as HTMLElement).style.transform = "translateY(-2px)";
            }}
            onMouseLeave={e => {
              (e.currentTarget as HTMLElement).style.borderColor = "var(--color-landing-btn-secondary-border, rgba(255,255,255,0.12))";
              (e.currentTarget as HTMLElement).style.transform = "none";
            }}
          >
            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <polyline points="4 17 10 11 4 5" />
              <line x1="12" y1="19" x2="20" y2="19" />
            </svg>
            <span>Install CLI</span>
          </a>

          {/* Tertiary CTA — Docs */}
          <a
            href={DOCS_URL}
            target="_blank"
            rel="noopener noreferrer"
            style={{
              display: "inline-flex",
              alignItems: "center",
              justifyContent: "center",
              gap: "8px",
              padding: "16px 24px",
              fontSize: "15px",
              fontWeight: 500,
              color: "var(--color-landing-subtext, #8888aa)",
              background: "transparent",
              borderRadius: "12px",
              textDecoration: "none",
              border: "1px solid transparent",
              transition: "all 0.2s ease",
            }}
            onMouseEnter={e => {
              (e.currentTarget as HTMLElement).style.color = "var(--color-landing-heading, #f0f0ff)";
              (e.currentTarget as HTMLElement).style.borderColor = "var(--color-landing-card-border, rgba(255,255,255,0.08))";
            }}
            onMouseLeave={e => {
              (e.currentTarget as HTMLElement).style.color = "var(--color-landing-subtext, #8888aa)";
              (e.currentTarget as HTMLElement).style.borderColor = "transparent";
            }}
          >
            Docs
          </a>
        </div>

        {/* Safety reassurance microcopy */}
        <div style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: "8px", color: "var(--color-landing-subtext, #6a6a8a)", fontSize: "12px", marginBottom: "44px" }}>
          <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#22c55e" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
            <path d="m9 12 2 2 4-4" />
          </svg>
          <span>100% safe &amp; containerized · Zero host changes · Instant clean teardown</span>
        </div>

        {/* Live metric / feature strip */}
        <div
          className="animate-fade-in-up-4"
          style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: "28px", flexWrap: "wrap" }}
        >
          <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#4ade80" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <circle cx="12" cy="12" r="10" />
              <polyline points="12 6 12 12 16 14" />
            </svg>
            <span style={{ fontSize: "12px", color: "var(--color-landing-subtext, #8888aa)", fontFamily: "JetBrains Mono, monospace" }}>
              Self-paced &amp; hands-on
            </span>
          </div>

          <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#38bdf8" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <rect x="2" y="7" width="20" height="14" rx="2" ry="2" />
              <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
            </svg>
            <span style={{ fontSize: "12px", color: "#8888aa", fontFamily: "JetBrains Mono, monospace" }}>
              Disposable Docker Sandboxes
            </span>
          </div>

          <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#a855f7" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
            </svg>
            <span style={{ fontSize: "12px", color: "#8888aa", fontFamily: "JetBrains Mono, monospace" }}>
              Verified XP &amp; Achievements
            </span>
          </div>
        </div>
      </div>

      {/* ── Floating terminal preview ──────────── */}
      <div
        className="animate-fade-in-up-5"
        style={{
          position: "relative",
          zIndex: 10,
          marginTop: "56px",
          width: "100%",
          maxWidth: "720px",
        }}
      >
        <div className="terminal-window">
          <div className="terminal-header">
            <div className="terminal-dot" style={{ background: "#ff5f57" }} />
            <div className="terminal-dot" style={{ background: "#febc2e" }} />
            <div className="terminal-dot" style={{ background: "#28c840" }} />
            <span style={{
              marginLeft: "10px",
              fontSize: "12px",
              color: "#4a4a6a",
              fontFamily: "JetBrains Mono, monospace",
            }}>
              ~ / tld
            </span>
            <div style={{ marginLeft: "auto", display: "flex", gap: "12px" }}>
              <span style={{ fontSize: "11px", color: "#4a4a6a", fontFamily: "monospace" }}>bash</span>
            </div>
          </div>
          <div style={{
            padding: "20px 24px",
            fontFamily: "JetBrains Mono, monospace",
            fontSize: "13px",
            lineHeight: 1.8,
          }}>
            <div style={{ color: "#4a4a6a", marginBottom: "4px" }}># Start an isolated troubleshooting lab</div>
            <div style={{ marginBottom: "4px" }}>
              <span style={{ color: "#22c55e" }}>❯</span>
              {" "}<span style={{ color: "#f0f0ff" }}>tld start docker-fundamentals</span>
            </div>
            <div style={{ color: "#22c55e", marginBottom: "2px", paddingLeft: "12px" }}>
              [ok] Sandboxed container ready — scenario active
            </div>
            <div style={{ color: "#4a4a6a", paddingLeft: "12px", marginBottom: "12px" }}>
              → Diagnose the crash. Fix the configuration. Validate.
            </div>
            <div style={{ marginBottom: "4px" }}>
              <span style={{ color: "#22c55e" }}>❯</span>
              {" "}<span style={{ color: "#f0f0ff" }}>tld check</span>
            </div>
            <div style={{ color: "#22c55e", paddingLeft: "12px", marginBottom: "4px" }}>
              [ok] All 5 system assertions passed
            </div>
            <div style={{ paddingLeft: "12px", color: "#a855f7" }}>
              +50 XP awarded · Rank promoted: <span style={{ color: "#e879f9" }}>Container Engineer II</span>
            </div>
            <div style={{ marginTop: "12px" }}>
              <span style={{ color: "#22c55e" }}>❯</span>
              {" "}
              <span className="animate-blink" style={{ color: "#f0f0ff", borderRight: "2px solid #22c55e", paddingRight: "2px" }}>
                {" "}
              </span>
            </div>
          </div>
        </div>

        {/* Glow under terminal */}
        <div style={{
          position: "absolute",
          bottom: "-30px",
          left: "50%",
          transform: "translateX(-50%)",
          width: "80%",
          height: "60px",
          background: "radial-gradient(ellipse, rgba(34,197,94,0.12) 0%, transparent 70%)",
          filter: "blur(20px)",
          pointerEvents: "none",
        }} />
      </div>

      {/* Scroll indicator */}
      <div style={{
        position: "absolute",
        bottom: "24px",
        left: "50%",
        transform: "translateX(-50%)",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        gap: "6px",
        opacity: 0.4,
      }}>
        <span style={{ fontSize: "10px", fontFamily: "monospace", letterSpacing: "0.1em", color: "#8888aa" }}>scroll</span>
        <div style={{
          width: "20px",
          height: "32px",
          border: "1.5px solid rgba(136,136,170,0.4)",
          borderRadius: "10px",
          display: "flex",
          justifyContent: "center",
          paddingTop: "4px",
        }}>
          <div
            className="animate-float"
            style={{
              width: "4px",
              height: "8px",
              borderRadius: "2px",
              background: "#22c55e",
              animationDuration: "1.5s",
            }}
          />
        </div>
      </div>
    </section>
  );
}
