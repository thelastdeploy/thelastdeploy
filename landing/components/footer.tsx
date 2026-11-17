"use client";

import { SOCIAL_LINKS, APP_URL, DOCS_URL } from "@/lib/constants";

const footerLinks = [
  { label: "Dashboard", href: APP_URL },
  { label: "Sign Up", href: `${APP_URL}/register` },
  { label: "Log In", href: `${APP_URL}/login` },
  { label: "Docs", href: DOCS_URL },
  { label: "GitHub", href: SOCIAL_LINKS.github },
  { label: "Discord", href: SOCIAL_LINKS.discord },
];

export default function Footer() {
  return (
    <footer style={{
      position: "relative",
      borderTop: "1px solid rgba(255,255,255,0.05)",
      padding: "32px 24px",
    }}>
      {/* top accent line */}
      <div style={{
        position: "absolute",
        top: 0,
        left: 0,
        right: 0,
        height: "1px",
        background: "linear-gradient(90deg, transparent, rgba(34,197,94,0.2) 30%, rgba(168,85,247,0.2) 70%, transparent)",
      }} />

      <div style={{ maxWidth: "1100px", margin: "0 auto" }}>
        <div style={{
          display: "flex",
          flexDirection: "row",
          flexWrap: "wrap",
          alignItems: "center",
          justifyContent: "space-between",
          gap: "16px",
        }}>
          {/* Logo */}
          <a
            href="/"
            aria-label="The Last Deploy — home"
            style={{ display: "flex", alignItems: "center", gap: "8px", textDecoration: "none" }}
          >
            <span style={{
              fontFamily: "JetBrains Mono, monospace",
              fontSize: "14px",
              fontWeight: 700,
            }}>
              <span style={{ color: "#22c55e" }}>~/</span>
              <span style={{ color: "var(--color-landing-heading, #f0f0ff)" }}>tld</span>
            </span>
          </a>

          {/* Links */}
          <nav style={{ display: "flex", gap: "24px", alignItems: "center" }}>
            {footerLinks.map((link) => (
              <a
                key={link.label}
                href={link.href}
                target="_blank"
                rel="noopener noreferrer"
                style={{
                  fontSize: "13px",
                  color: "var(--color-landing-subtext, #4a4a6a)",
                  textDecoration: "none",
                  transition: "color 0.2s ease",
                }}
                onMouseEnter={e => { (e.currentTarget as HTMLElement).style.color = "var(--color-landing-heading, #a0a0cc)"; }}
                onMouseLeave={e => { (e.currentTarget as HTMLElement).style.color = "var(--color-landing-subtext, #4a4a6a)"; }}
              >
                {link.label}
              </a>
            ))}
          </nav>

          {/* Copyright */}
          <p style={{ fontSize: "12px", color: "var(--color-landing-subtext, #3a3a5a)", display: "inline-flex", alignItems: "center", gap: "5px" }}>
            <span>© {new Date().getFullYear()} The Last Deploy · Open Source</span>
            <span style={{ color: "#22c55e", display: "inline-flex", alignItems: "center" }}>
              <svg width="11" height="11" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
              </svg>
            </span>
          </p>
        </div>
      </div>
    </footer>
  );
}
