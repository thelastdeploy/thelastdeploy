"use client";

import { useState, useEffect } from "react";
import { SOCIAL_LINKS, DOCS_URL, APP_URL } from "@/lib/constants";
import ThemeToggle from "@/components/theme-toggle";

export default function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 30);
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  return (
    <header
      style={{
        position: "fixed",
        top: 0,
        left: 0,
        right: 0,
        zIndex: 50,
        transition: "all 0.4s cubic-bezier(0.16, 1, 0.3, 1)",
        background: scrolled
          ? "var(--color-landing-nav-bg, rgba(7, 7, 16, 0.92))"
          : "transparent",
        backdropFilter: scrolled ? "blur(20px)" : "none",
        WebkitBackdropFilter: scrolled ? "blur(20px)" : "none",
        borderBottom: scrolled
          ? "1px solid var(--color-landing-nav-border, rgba(255,255,255,0.06))"
          : "1px solid transparent",
      }}
    >
      {/* Top accent line */}
      {scrolled && (
        <div style={{
          position: "absolute",
          top: 0,
          left: 0,
          right: 0,
          height: "1px",
          background: "linear-gradient(90deg, transparent, rgba(34,197,94,0.4), transparent)",
        }} />
      )}

      <div style={{ maxWidth: "1200px", margin: "0 auto", padding: "0 24px" }}>
        <div style={{ display: "flex", height: "64px", alignItems: "center", justifyContent: "space-between" }}>

          {/* Logo */}
          <a href="/" style={{ display: "flex", alignItems: "center", gap: "10px", textDecoration: "none", flexShrink: 0 }}>
            <img
              src="/logo.png"
              alt="Logo"
              style={{
                height: "36px",
                width: "auto",
                objectFit: "contain",
                display: "block",
              }}
            />
            <span style={{
              fontSize: "15px",
              fontWeight: 700,
              letterSpacing: "-0.03em",
              color: "var(--color-landing-heading, #f0f0ff)",
            }}>
              The Last Deploy
            </span>
          </a>

          {/* Desktop Nav */}
          <nav className="navbar-desktop" style={{ display: "flex", alignItems: "center", gap: "8px" }}>
            {/* Tracks */}
            <a
              href="#tracks"
              style={{
                display: "inline-flex",
                alignItems: "center",
                padding: "8px 12px",
                fontSize: "13px",
                fontWeight: 500,
                color: "var(--color-landing-subtext, #8888aa)",
                textDecoration: "none",
                borderRadius: "8px",
                transition: "all 0.2s ease",
              }}
              onMouseEnter={e => {
                (e.currentTarget as HTMLElement).style.color = "var(--color-landing-heading, #f0f0ff)";
              }}
              onMouseLeave={e => {
                (e.currentTarget as HTMLElement).style.color = "var(--color-landing-subtext, #8888aa)";
              }}
            >
              Tracks
            </a>

            {/* How It Works */}
            <a
              href="#how-it-works"
              style={{
                display: "inline-flex",
                alignItems: "center",
                padding: "8px 12px",
                fontSize: "13px",
                fontWeight: 500,
                color: "var(--color-landing-subtext, #8888aa)",
                textDecoration: "none",
                borderRadius: "8px",
                transition: "all 0.2s ease",
              }}
              onMouseEnter={e => {
                (e.currentTarget as HTMLElement).style.color = "var(--color-landing-heading, #f0f0ff)";
              }}
              onMouseLeave={e => {
                (e.currentTarget as HTMLElement).style.color = "var(--color-landing-subtext, #8888aa)";
              }}
            >
              How It Works
            </a>

            {/* Docs */}
            <a
              href={DOCS_URL}
              target="_blank"
              rel="noopener noreferrer"
              style={{
                display: "inline-flex",
                alignItems: "center",
                padding: "8px 12px",
                fontSize: "13px",
                fontWeight: 500,
                color: "var(--color-landing-subtext, #8888aa)",
                textDecoration: "none",
                borderRadius: "8px",
                transition: "all 0.2s ease",
              }}
              onMouseEnter={e => {
                (e.currentTarget as HTMLElement).style.color = "var(--color-landing-heading, #f0f0ff)";
              }}
              onMouseLeave={e => {
                (e.currentTarget as HTMLElement).style.color = "var(--color-landing-subtext, #8888aa)";
              }}
            >
              Docs
            </a>

            {/* GitHub */}
            <a
              href={SOCIAL_LINKS.github}
              target="_blank"
              rel="noopener noreferrer"
              style={{
                display: "inline-flex",
                alignItems: "center",
                gap: "6px",
                padding: "8px 12px",
                fontSize: "13px",
                fontWeight: 500,
                color: "var(--color-landing-subtext, #8888aa)",
                textDecoration: "none",
                borderRadius: "8px",
                transition: "all 0.2s ease",
              }}
              onMouseEnter={e => {
                (e.currentTarget as HTMLElement).style.color = "var(--color-landing-heading, #f0f0ff)";
              }}
              onMouseLeave={e => {
                (e.currentTarget as HTMLElement).style.color = "var(--color-landing-subtext, #8888aa)";
              }}
            >
              <svg viewBox="0 0 24 24" fill="currentColor" width="15" height="15">
                <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z" />
              </svg>
              GitHub
            </a>

            <div style={{ width: "1px", height: "20px", background: "var(--color-border, rgba(255,255,255,0.1))", margin: "0 4px" }} />

            {/* Login */}
            <a
              href={`${APP_URL}/login`}
              style={{
                display: "inline-flex",
                alignItems: "center",
                padding: "8px 14px",
                fontSize: "13px",
                fontWeight: 600,
                color: "var(--color-landing-subtext, #c0c0d8)",
                textDecoration: "none",
                borderRadius: "8px",
                transition: "all 0.2s ease",
              }}
              onMouseEnter={e => {
                (e.currentTarget as HTMLElement).style.color = "var(--color-landing-heading, #f0f0ff)";
              }}
              onMouseLeave={e => {
                (e.currentTarget as HTMLElement).style.color = "var(--color-landing-subtext, #c0c0d8)";
              }}
            >
              Log in
            </a>

            {/* Start Free Button */}
            <a
              href={`${APP_URL}/register`}
              style={{
                display: "inline-flex",
                alignItems: "center",
                gap: "6px",
                padding: "8px 18px",
                fontSize: "13px",
                fontWeight: 700,
                color: "#030a04",
                background: "linear-gradient(135deg, #22c55e 0%, #4ade80 100%)",
                borderRadius: "9px",
                textDecoration: "none",
                boxShadow: "0 0 16px rgba(34,197,94,0.3)",
                transition: "transform 0.2s ease, box-shadow 0.2s ease",
              }}
              onMouseEnter={e => {
                (e.currentTarget as HTMLElement).style.transform = "translateY(-1px)";
                (e.currentTarget as HTMLElement).style.boxShadow = "0 0 24px rgba(34,197,94,0.45)";
              }}
              onMouseLeave={e => {
                (e.currentTarget as HTMLElement).style.transform = "none";
                (e.currentTarget as HTMLElement).style.boxShadow = "0 0 16px rgba(34,197,94,0.3)";
              }}
            >
              <span>Start Free</span>
              <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                <path d="M5 12h14" />
                <path d="m12 5 7 7-7 7" />
              </svg>
            </a>

            {/* Theme Toggle */}
            <ThemeToggle />
          </nav>

          {/* Mobile Right Controls */}
          <div className="navbar-mobile" style={{ display: "none", alignItems: "center", gap: "8px" }}>
            <a
              href={`${APP_URL}/register`}
              style={{
                display: "inline-flex",
                alignItems: "center",
                padding: "6px 14px",
                fontSize: "12px",
                fontWeight: 700,
                color: "#030a04",
                background: "linear-gradient(135deg, #22c55e 0%, #4ade80 100%)",
                borderRadius: "8px",
                textDecoration: "none",
              }}
            >
              Start Free
            </a>

            <ThemeToggle />

            {/* Hamburger Button */}
            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              aria-label="Toggle navigation"
              style={{
                display: "inline-flex",
                alignItems: "center",
                justifyContent: "center",
                padding: "8px",
                background: "transparent",
                border: "1px solid var(--color-landing-nav-border, rgba(255,255,255,0.08))",
                borderRadius: "8px",
                color: "var(--color-landing-heading, #f0f0ff)",
                cursor: "pointer",
              }}
            >
              {mobileMenuOpen ? (
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M18 6L6 18" />
                  <path d="M6 6l12 12" />
                </svg>
              ) : (
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <line x1="4" x2="20" y1="12" y2="12" />
                  <line x1="4" x2="20" y1="6" y2="6" />
                  <line x1="4" x2="20" y1="18" y2="18" />
                </svg>
              )}
            </button>
          </div>

        </div>
      </div>

      {/* Mobile Dropdown Menu */}
      {mobileMenuOpen && (
        <div
          style={{
            background: "var(--color-landing-nav-bg, rgba(7, 7, 16, 0.98))",
            borderBottom: "1px solid var(--color-landing-nav-border, rgba(255,255,255,0.08))",
            padding: "16px 24px 24px",
            display: "flex",
            flexDirection: "column",
            gap: "12px",
          }}
        >
          <a
            href="#tracks"
            onClick={() => setMobileMenuOpen(false)}
            style={{ color: "var(--color-landing-heading, #f0f0ff)", textDecoration: "none", fontSize: "15px", fontWeight: 500, padding: "8px 0" }}
          >
            Tracks
          </a>
          <a
            href="#how-it-works"
            onClick={() => setMobileMenuOpen(false)}
            style={{ color: "var(--color-landing-heading, #f0f0ff)", textDecoration: "none", fontSize: "15px", fontWeight: 500, padding: "8px 0" }}
          >
            How It Works
          </a>
          <a
            href={DOCS_URL}
            target="_blank"
            rel="noopener noreferrer"
            style={{ color: "var(--color-landing-heading, #f0f0ff)", textDecoration: "none", fontSize: "15px", fontWeight: 500, padding: "8px 0" }}
          >
            Documentation
          </a>
          <a
            href={SOCIAL_LINKS.github}
            target="_blank"
            rel="noopener noreferrer"
            style={{ color: "var(--color-landing-heading, #f0f0ff)", textDecoration: "none", fontSize: "15px", fontWeight: 500, padding: "8px 0" }}
          >
            Star on GitHub
          </a>
          <div style={{ height: "1px", background: "var(--color-landing-nav-border, rgba(255,255,255,0.08))", margin: "8px 0" }} />
          <a
            href={`${APP_URL}/login`}
            style={{
              textAlign: "center",
              padding: "12px",
              borderRadius: "10px",
              border: "1px solid var(--color-landing-btn-secondary-border, rgba(255,255,255,0.12))",
              color: "var(--color-landing-heading, #f0f0ff)",
              background: "var(--color-landing-btn-secondary-bg, transparent)",
              textDecoration: "none",
              fontWeight: 600,
              fontSize: "14px",
            }}
          >
            Log in to Dashboard
          </a>
          <a
            href={`${APP_URL}/register`}
            style={{
              textAlign: "center",
              padding: "12px",
              borderRadius: "10px",
              background: "linear-gradient(135deg, #22c55e 0%, #4ade80 100%)",
              color: "#030a04",
              textDecoration: "none",
              fontWeight: 700,
              fontSize: "14px",
            }}
          >
            Start Practicing Free
          </a>
        </div>
      )}

      <style>{`
        @media (max-width: 860px) {
          .navbar-desktop { display: none !important; }
          .navbar-mobile  { display: flex !important; }
        }
      `}</style>
    </header>
  );
}
