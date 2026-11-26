"use client";

import { useState, useEffect } from "react";

const TrophyIcon = (props: React.SVGProps<SVGSVGElement>) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" {...props}>
    <path d="M6 9H4a2 2 0 0 1-2-2V5h4" />
    <path d="M18 9h2a2 2 0 0 0 2-2V5h-4" />
    <path d="M6 2h12v7a6 6 0 0 1-12 0Z" />
    <path d="M12 15v4" />
    <path d="M8 19h8" />
    <path d="M9 19v2" />
    <path d="M15 19v2" />
  </svg>
);

const ZapIcon = (props: React.SVGProps<SVGSVGElement>) => (
  <svg viewBox="0 0 24 24" fill="currentColor" {...props}>
    <path d="M13 2L4.5 13.5H11L10 22L20.5 10.5H14L13 2Z" />
  </svg>
);

const tracks = [
  { label: "Docker", pct: 80, color: "#3b82f6" },
  { label: "Kubernetes", pct: 55, color: "#a855f7" },
  { label: "Linux", pct: 92, color: "#f59e0b" },
  { label: "Git", pct: 67, color: "#ec4899" },
];

const avatarColors = ["#16a34a", "#3b82f6", "#f59e0b", "#ec4899", "#8b5cf6"];

function AnimatedTerminal() {
  const lines = [
    { text: "$ tld check dkr-backup-volume", type: "cmd" },
    { text: "✓ Found named volume prod-db-vol", type: "ok" },
    { text: "✓ Asserted backup.tar exists", type: "ok" },
    { text: "✓ Lab passed! +20 XP awarded", type: "success" },
  ];
  const [visible, setVisible] = useState(0);

  useEffect(() => {
    if (visible >= lines.length) return;
    const t = setTimeout(() => setVisible((v) => v + 1), 700 + visible * 300);
    return () => clearTimeout(t);
  }, [visible, lines.length]);

  return (
    <div className="bg-[#09090b] border border-white/10 rounded-xl p-4 font-mono text-xs space-y-1.5 shadow-inner select-none">
      <div className="flex items-center gap-1.5 border-b border-white/10 pb-2 mb-3">
        <span className="w-2.5 h-2.5 rounded-full bg-[#ff5f57]" />
        <span className="w-2.5 h-2.5 rounded-full bg-[#febc2e]" />
        <span className="w-2.5 h-2.5 rounded-full bg-[#28c840]" />
        <span className="text-[10px] text-white/30 ml-2">tld — zsh</span>
      </div>
      {lines.slice(0, visible).map((l, i) => (
        <p
          key={i}
          className={
            l.type === "cmd"
              ? "text-[var(--accent-primary)]"
              : l.type === "ok"
              ? "text-emerald-400/90"
              : "text-white font-bold"
          }
          style={{ animation: "fadeSlideIn 0.3s ease forwards" }}
        >
          {l.text}
        </p>
      ))}
      {visible < lines.length && (
        <span className="inline-block w-2 h-3.5 bg-[var(--accent-primary)] opacity-80 align-middle animate-pulse" />
      )}
    </div>
  );
}

export function ShowcasePanel() {
  return (
    <div className="hidden lg:flex flex-1 relative items-center justify-center p-12 overflow-hidden border-l border-border dark:border-white/[0.06]">
      <div className="absolute inset-0 bg-gradient-to-br from-slate-100 via-slate-50 to-white dark:from-[#0a0a0f] dark:via-[#0a0a0f] dark:to-[#0a0a0f]" />
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_60%_50%_at_70%_40%,rgba(22,163,74,0.10),transparent)] dark:bg-[radial-gradient(ellipse_60%_50%_at_70%_40%,rgba(22,163,74,0.12),transparent)]" />
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_40%_30%_at_20%_80%,rgba(59,130,246,0.06),transparent)] dark:bg-[radial-gradient(ellipse_40%_30%_at_20%_80%,rgba(59,130,246,0.08),transparent)]" />
      <div className="absolute inset-0 bg-[linear-gradient(rgba(0,0,0,0.04)_1px,transparent_1px),linear-gradient(90deg,rgba(0,0,0,0.04)_1px,transparent_1px)] dark:bg-[linear-gradient(rgba(255,255,255,0.025)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.025)_1px,transparent_1px)] bg-[size:40px_40px]" />

      <div className="absolute top-16 right-16 w-32 h-32 rounded-full bg-[var(--accent-primary)]/10 blur-3xl animate-pulse" />
      <div className="absolute bottom-24 left-12 w-24 h-24 rounded-full bg-blue-500/10 blur-3xl animate-pulse" style={{ animationDelay: "1s" }} />

      <div
        className="absolute top-8 right-8 flex items-center gap-2.5 bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 backdrop-blur-sm rounded-xl px-3.5 py-2.5 shadow-xl"
        style={{ animation: "floatBadge 3s ease-in-out infinite" }}
      >
        <TrophyIcon className="w-5 h-5 text-amber-500 shrink-0" />
        <div className="text-[11px] leading-tight">
          <p className="font-bold text-slate-800 dark:text-white/90">Achievement Unlocked!</p>
          <p className="text-slate-500 dark:text-white/50">Docker Master · +100 XP</p>
        </div>
      </div>

      <div className="max-w-md w-full space-y-5 relative z-10">
        <div className="bg-black/[0.04] dark:bg-white/[0.04] border border-black/10 dark:border-white/10 rounded-2xl p-6 backdrop-blur-sm shadow-2xl space-y-5">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-slate-400 dark:text-white/40 text-[11px] uppercase tracking-widest font-semibold">Your Progress</p>
              <h3 className="text-slate-800 dark:text-white font-black text-lg mt-0.5">Track Dashboard</h3>
            </div>
            <div className="flex flex-col items-end gap-1">
              <div className="flex items-center gap-1.5 bg-[var(--accent-primary)]/15 border border-[var(--accent-primary)]/30 rounded-lg px-2.5 py-1">
                <span className="text-[var(--accent-primary)] text-xs font-black flex items-center gap-0.5"><ZapIcon className="w-3 h-3" /> 1,240 XP</span>
              </div>
              <p className="text-slate-400 dark:text-white/30 text-[10px]">Rank #47</p>
            </div>
          </div>

          <div className="space-y-3">
            {tracks.map((track) => (
              <div key={track.label} className="space-y-1.5">
                <div className="flex justify-between items-center">
                  <span className="text-slate-600 dark:text-white/70 text-xs font-semibold">{track.label}</span>
                  <span className="text-slate-400 dark:text-white/40 text-[11px]">{track.pct}%</span>
                </div>
                <div className="h-1.5 rounded-full bg-black/[0.06] dark:bg-white/[0.06] overflow-hidden">
                  <div
                    className="h-full rounded-full"
                    style={{
                      width: `${track.pct}%`,
                      background: `linear-gradient(90deg, ${track.color}80, ${track.color})`,
                      boxShadow: `0 0 8px ${track.color}60`,
                      animation: "barGrow 1s ease forwards",
                    }}
                  />
                </div>
              </div>
            ))}
          </div>

          <div className="flex items-center gap-3 pt-1 border-t border-black/[0.06] dark:border-white/[0.06]">
            <div className="flex -space-x-2">
              {avatarColors.map((c, i) => (
                <div
                  key={i}
                  className="w-7 h-7 rounded-full border-2 border-slate-100 dark:border-[#0a0a0f] flex items-center justify-center text-[10px] font-black text-white"
                  style={{ background: c }}
                >
                  {String.fromCharCode(65 + i)}
                </div>
              ))}
            </div>
            <p className="text-slate-400 dark:text-white/40 text-[11px]">
              <span className="text-slate-600 dark:text-white/70 font-bold">2,400+</span> engineers learning today
            </p>
          </div>
        </div>

        <AnimatedTerminal />

        <div className="text-center space-y-1 pt-1">
          <h2 className="text-white font-black text-xl tracking-tight">Master DevOps & Automation</h2>
          <p className="text-white/40 text-sm leading-relaxed">
            Real challenges. Real terminal. Real skills.
          </p>
        </div>
      </div>
    </div>
  );
}

