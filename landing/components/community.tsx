"use client";

import { SOCIAL_LINKS } from "@/lib/constants";

const socials = [
  {
    name: "GitHub",
    href: SOCIAL_LINKS.github,
    handle: "@thelastdeploy",
    description: "Star the repo, open issues, contribute to labs and the platform",
    accent: "#f0f0ff",
    bg: "rgba(240,240,255,0.04)",
    border: "rgba(240,240,255,0.08)",
    icon: (
      <svg viewBox="0 0 24 24" fill="currentColor" width="22" height="22">
        <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z" />
      </svg>
    ),
  },
  {
    name: "LinkedIn",
    href: SOCIAL_LINKS.linkedin,
    handle: "thelastdeploy",
    description: "Follow us on LinkedIn for platform updates and news",
    accent: "#f0f0ff",
    bg: "rgba(10,102,194,0.05)",
    border: "rgba(10,102,194,0.15)",
    icon: (
      <svg viewBox="0 0 24 24" fill="currentColor" width="22" height="22">
        <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.779-1.75-1.75s.784-1.75 1.75-1.75 1.75.779 1.75 1.75-.784 1.75-1.75 1.75zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"/>
      </svg>
    ),
  },
];

export default function Community() {
  return (
    <section
      className="section-divider"
      style={{ padding: "96px 24px", position: "relative", overflow: "hidden" }}
    >
      <div style={{
        position: "absolute",
        bottom: 0,
        left: "50%",
        transform: "translateX(-50%)",
        width: "600px",
        height: "200px",
        background: "radial-gradient(ellipse, rgba(88,101,242,0.05) 0%, transparent 70%)",
        pointerEvents: "none",
      }} />

      <div style={{ maxWidth: "900px", margin: "0 auto", position: "relative", zIndex: 1 }}>
        {/* Header */}
        <div style={{ textAlign: "center", marginBottom: "56px" }}>
          <div style={{ marginBottom: "16px" }}>
            <span className="section-badge" style={{
              borderColor: "rgba(88,101,242,0.25)",
              background: "rgba(88,101,242,0.06)",
              color: "#818cf8",
            }}>
              Community
            </span>
          </div>
          <h2 style={{
            fontSize: "clamp(28px, 4vw, 48px)",
            fontWeight: 800,
            letterSpacing: "-0.03em",
            lineHeight: 1.1,
            marginBottom: "16px",
          }}>
            Follow the journey
          </h2>
          <p style={{ fontSize: "18px", color: "#8888aa", maxWidth: "400px", margin: "0 auto", lineHeight: 1.6 }}>
            We build in public. Watch, star, and become part of it.
          </p>
        </div>

        {/* Social cards */}
        <div style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(280px, 1fr))",
          gap: "16px",
          maxWidth: "720px",
          margin: "0 auto",
        }}>
          {socials.map((social) => (
            <a
              key={social.name}
              href={social.href}
              target="_blank"
              rel="noopener noreferrer"
              style={{
                display: "flex",
                flexDirection: "column",
                gap: "12px",
                padding: "28px",
                borderRadius: "16px",
                background: social.bg,
                border: `1px solid ${social.border}`,
                backdropFilter: "blur(12px)",
                textDecoration: "none",
                transition: "all 0.3s cubic-bezier(0.16, 1, 0.3, 1)",
              }}
              onMouseEnter={e => {
                const el = e.currentTarget as HTMLElement;
                el.style.transform = "translateY(-3px)";
                el.style.boxShadow = `0 0 24px ${social.bg.replace("0.04", "0.15").replace("0.05", "0.15")}, 0 16px 32px rgba(0,0,0,0.3)`;
                el.style.borderColor = social.accent + "35";
              }}
              onMouseLeave={e => {
                const el = e.currentTarget as HTMLElement;
                el.style.transform = "none";
                el.style.boxShadow = "none";
                el.style.borderColor = social.border;
              }}
            >
              <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
                <div style={{ color: social.accent }}>
                  {social.icon}
                </div>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#4a4a6a" strokeWidth="2">
                  <path d="M7 17l9.2-9.2M17 17V7H7" />
                </svg>
              </div>
              <div>
                <h3 style={{ fontSize: "16px", fontWeight: 700, color: "#f0f0ff", marginBottom: "4px" }}>
                  {social.name}
                </h3>
                <p style={{ fontSize: "12px", color: "#4a4a6a", fontFamily: "JetBrains Mono, monospace", marginBottom: "8px" }}>
                  {social.handle}
                </p>
                <p style={{ fontSize: "13px", color: "#6a6a8a", lineHeight: 1.55 }}>
                  {social.description}
                </p>
              </div>
            </a>
          ))}
        </div>
      </div>
    </section>
  );
}
