"use client";

import { SOCIAL_LINKS, APP_URL } from "@/lib/constants";

export default function CTA() {
  return (
    <section
      id="cta"
      style={{
        position: "relative",
        padding: "100px 24px 120px",
        overflow: "hidden",
      }}
    >
      {/* Border top with glow */}
      <div style={{
        position: "absolute",
        top: 0,
        left: 0,
        right: 0,
        height: "1px",
        background: "linear-gradient(90deg, transparent, rgba(34,197,94,0.5) 30%, rgba(56,189,248,0.4) 70%, transparent)",
      }} />

      {/* Big ambient glow */}
      <div
        className="animate-float-slow"
        style={{
          position: "absolute",
          top: "0%",
          left: "50%",
          transform: "translateX(-50%)",
          width: "900px",
          height: "600px",
          background: "radial-gradient(ellipse at center, rgba(34,197,94,0.1) 0%, rgba(56,189,248,0.04) 40%, transparent 70%)",
          filter: "blur(40px)",
          pointerEvents: "none",
        }}
      />

      {/* Grid overlay */}
      <div style={{
        position: "absolute",
        inset: 0,
        backgroundImage: `
          linear-gradient(rgba(34,197,94,0.03) 1px, transparent 1px),
          linear-gradient(90deg, rgba(34,197,94,0.03) 1px, transparent 1px)
        `,
        backgroundSize: "48px 48px",
        maskImage: "radial-gradient(ellipse 80% 100% at 50% 50%, black 40%, transparent 100%)",
        WebkitMaskImage: "radial-gradient(ellipse 80% 100% at 50% 50%, black 40%, transparent 100%)",
      }} />

      <div style={{
        position: "relative",
        zIndex: 10,
        maxWidth: "680px",
        margin: "0 auto",
        textAlign: "center",
      }}>
        {/* Badge */}
        <div style={{ marginBottom: "24px" }}>
          <span className="section-badge" style={{
            borderColor: "rgba(34,197,94,0.3)",
            background: "rgba(34,197,94,0.08)",
            color: "#4ade80",
          }}>
            <span style={{
              width: "6px",
              height: "6px",
              borderRadius: "50%",
              background: "#22c55e",
              display: "inline-block",
              boxShadow: "0 0 6px rgba(34,197,94,0.8)",
            }} />
            Free &amp; Open Source Platform
          </span>
        </div>

        <h2 style={{
          fontSize: "clamp(32px, 5vw, 56px)",
          fontWeight: 800,
          letterSpacing: "-0.04em",
          lineHeight: 1.1,
          marginBottom: "20px",
          color: "var(--color-landing-heading, #f0f0ff)",
        }}>
          Ready to debug like a{" "}
          <span className="text-gradient">
            senior engineer?
          </span>
        </h2>

        <p style={{
          fontSize: "17px",
          color: "var(--color-landing-subtext, #8888aa)",
          lineHeight: 1.65,
          maxWidth: "520px",
          margin: "0 auto 36px",
        }}>
          Pick a track, review the playbook, and start troubleshooting in disposable, safe sandbox containers. Free forever, with zero credit card required.
        </p>

        {/* Primary Signup CTAs */}
        <div style={{ display: "flex", flexDirection: "row", flexWrap: "wrap", justifyContent: "center", gap: "14px", marginBottom: "32px" }}>
          <a
            href={`${APP_URL}/register`}
            style={{
              display: "inline-flex",
              alignItems: "center",
              justifyContent: "center",
              gap: "10px",
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
              (e.currentTarget as HTMLElement).style.boxShadow = "0 0 36px rgba(34,197,94,0.5)";
            }}
            onMouseLeave={e => {
              (e.currentTarget as HTMLElement).style.transform = "none";
              (e.currentTarget as HTMLElement).style.boxShadow = "0 0 24px rgba(34,197,94,0.35)";
            }}
          >
            <span>Create Free Account</span>
            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <path d="M5 12h14" />
              <path d="m12 5 7 7-7 7" />
            </svg>
          </a>

          <a
            href={`${APP_URL}/login`}
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
            <span>Log in to Dashboard</span>
          </a>
        </div>

        {/* Community Fallbacks */}
        <div style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: "20px", flexWrap: "wrap", color: "var(--color-landing-subtext, #6a6a8a)", fontSize: "13px" }}>
          <span>Join the community:</span>
          <a
            href={SOCIAL_LINKS.discord}
            target="_blank"
            rel="noopener noreferrer"
            style={{
              display: "inline-flex",
              alignItems: "center",
              gap: "6px",
              color: "var(--color-landing-subtext, #8888aa)",
              textDecoration: "none",
              transition: "color 0.2s ease",
            }}
            onMouseEnter={e => { (e.currentTarget as HTMLElement).style.color = "#5865F2"; }}
            onMouseLeave={e => { (e.currentTarget as HTMLElement).style.color = "var(--color-landing-subtext, #8888aa)"; }}
          >
            <svg viewBox="0 0 24 24" fill="currentColor" width="16" height="16">
              <path d="M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515.074.074 0 0 0-.079.037c-.21.375-.444.864-.608 1.25a18.27 18.27 0 0 0-5.487 0 12.64 12.64 0 0 0-.617-1.25.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.32 13.58.099 18.057c.002.022.015.043.033.054a19.9 19.9 0 0 0 5.993 3.03.078.078 0 0 0 .084-.028 14.09 14.09 0 0 0 1.226-1.994.076.076 0 0 0-.041-.106 13.107 13.107 0 0 1-1.872-.892.077.077 0 0 1-.008-.128 10.2 10.2 0 0 0 .372-.292.074.074 0 0 1 .077-.01c3.928 1.793 8.18 1.793 12.062 0a.074.074 0 0 1 .078.01c.12.098.246.198.373.292a.077.077 0 0 1-.006.127 12.299 12.299 0 0 1-1.873.892.077.077 0 0 0-.041.107c.36.698.772 1.362 1.225 1.993a.076.076 0 0 0 .084.028 19.839 19.839 0 0 0 6.002-3.03.077.077 0 0 0 .032-.054c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.03z"/>
            </svg>
            Discord
          </a>

          <a
            href={SOCIAL_LINKS.github}
            target="_blank"
            rel="noopener noreferrer"
            style={{
              display: "inline-flex",
              alignItems: "center",
              gap: "6px",
              color: "var(--color-landing-subtext, #8888aa)",
              textDecoration: "none",
              transition: "color 0.2s ease",
            }}
            onMouseEnter={e => { (e.currentTarget as HTMLElement).style.color = "var(--color-landing-heading, #f0f0ff)"; }}
            onMouseLeave={e => { (e.currentTarget as HTMLElement).style.color = "var(--color-landing-subtext, #8888aa)"; }}
          >
            <svg viewBox="0 0 24 24" fill="currentColor" width="16" height="16">
              <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z"/>
            </svg>
            GitHub
          </a>
        </div>
      </div>
    </section>
  );
}
