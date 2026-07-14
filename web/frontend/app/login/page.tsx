// web/frontend/app/login/page.tsx

"use client";

import { useState, Suspense, useEffect } from "react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

const GithubIcon = (props: React.SVGProps<SVGSVGElement>) => (
  <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round" {...props}>
    <path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22" />
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
    { text: "✓ Lab passed! +20 XP awarded 🎉", type: "success" },
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

function ShowcasePanel() {
  return (
    <div className="hidden lg:flex flex-1 relative items-center justify-center p-12 overflow-hidden border-l border-white/[0.06]">
      {/* Layered background */}
      <div className="absolute inset-0 bg-[#0a0a0f]" />
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_60%_50%_at_70%_40%,rgba(22,163,74,0.12),transparent)]" />
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_40%_30%_at_20%_80%,rgba(59,130,246,0.08),transparent)]" />
      {/* Grid */}
      <div className="absolute inset-0 bg-[linear-gradient(rgba(255,255,255,0.025)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.025)_1px,transparent_1px)] bg-[size:40px_40px]" />

      {/* Floating glow blobs */}
      <div className="absolute top-16 right-16 w-32 h-32 rounded-full bg-[var(--accent-primary)]/10 blur-3xl animate-pulse" />
      <div className="absolute bottom-24 left-12 w-24 h-24 rounded-full bg-blue-500/10 blur-3xl animate-pulse" style={{ animationDelay: "1s" }} />

      {/* Floating achievement toast */}
      <div
        className="absolute top-8 right-8 flex items-center gap-2.5 bg-white/5 border border-white/10 backdrop-blur-sm rounded-xl px-3.5 py-2.5 shadow-xl"
        style={{ animation: "floatBadge 3s ease-in-out infinite" }}
      >
        <span className="text-lg">🏆</span>
        <div className="text-[11px] leading-tight">
          <p className="font-bold text-white/90">Achievement Unlocked!</p>
          <p className="text-white/50">Docker Master · +100 XP</p>
        </div>
      </div>

      {/* Main card */}
      <div className="max-w-md w-full space-y-5 relative z-10">
        {/* Stats card */}
        <div className="bg-white/[0.04] border border-white/10 rounded-2xl p-6 backdrop-blur-sm shadow-2xl space-y-5">
          {/* Header */}
          <div className="flex items-center justify-between">
            <div>
              <p className="text-white/40 text-[11px] uppercase tracking-widest font-semibold">Your Progress</p>
              <h3 className="text-white font-black text-lg mt-0.5">Track Dashboard</h3>
            </div>
            <div className="flex flex-col items-end gap-1">
              <div className="flex items-center gap-1.5 bg-[var(--accent-primary)]/15 border border-[var(--accent-primary)]/30 rounded-lg px-2.5 py-1">
                <span className="text-[var(--accent-primary)] text-xs font-black">⚡ 1,240 XP</span>
              </div>
              <p className="text-white/30 text-[10px]">Rank #47</p>
            </div>
          </div>

          {/* Track progress bars */}
          <div className="space-y-3">
            {tracks.map((track) => (
              <div key={track.label} className="space-y-1.5">
                <div className="flex justify-between items-center">
                  <span className="text-white/70 text-xs font-semibold">{track.label}</span>
                  <span className="text-white/40 text-[11px]">{track.pct}%</span>
                </div>
                <div className="h-1.5 rounded-full bg-white/[0.06] overflow-hidden">
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

          {/* Avatar social proof */}
          <div className="flex items-center gap-3 pt-1 border-t border-white/[0.06]">
            <div className="flex -space-x-2">
              {avatarColors.map((c, i) => (
                <div
                  key={i}
                  className="w-7 h-7 rounded-full border-2 border-[#0a0a0f] flex items-center justify-center text-[10px] font-black text-white"
                  style={{ background: c }}
                >
                  {String.fromCharCode(65 + i)}
                </div>
              ))}
            </div>
            <p className="text-white/40 text-[11px]">
              <span className="text-white/70 font-bold">2,400+</span> engineers learning today
            </p>
          </div>
        </div>

        {/* Terminal */}
        <AnimatedTerminal />

        {/* Caption */}
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

function LoginContent() {
  const { login } = useAuth();
  const router = useRouter();
  const searchParams = useSearchParams();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [resendLoading, setResendLoading] = useState(false);
  const [resendMessage, setResendMessage] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setResendMessage(null);
    setLoading(true);
    try {
      const { access_token, device_key } = await api.login(email, password);
      await login(access_token, device_key);
      const redirect = searchParams.get("redirect") || "/dashboard";
      router.push(redirect);
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Login failed");
    } finally {
      setLoading(false);
    }
  };

  const handleResendVerification = async () => {
    if (!email) return;
    setResendLoading(true);
    setResendMessage(null);
    try {
      const res = await api.resendVerification(email);
      setResendMessage(res.detail);
    } catch (err: unknown) {
      setResendMessage(err instanceof Error ? err.message : "Failed to resend verification email");
    } finally {
      setResendLoading(false);
    }
  };

  const handleGithubLogin = () => {
    const clientId = process.env.NEXT_PUBLIC_GITHUB_CLIENT_ID;
    if (!clientId) {
      setError("GitHub Client ID is not configured on the client.");
      return;
    }
    const redirectUri = `${window.location.origin}/login/callback`;
    const githubAuthUrl = `https://github.com/login/oauth/authorize?client_id=${clientId}&redirect_uri=${encodeURIComponent(
      redirectUri
    )}&scope=user:email`;
    window.location.href = githubAuthUrl;
  };

  return (
    <div className="min-h-[calc(100vh-64px)] flex flex-col lg:flex-row transition-colors duration-300">
      {/* Left Column: Form */}
      <div className="flex-1 flex items-center justify-center px-6 py-12 relative">
        {/* Subtle bg glow behind logo */}
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-64 h-32 bg-[var(--accent-primary)]/5 blur-3xl rounded-full pointer-events-none" />

        <div className="w-full max-w-sm relative z-10">
          <div className="mb-8">
            <div className="mb-5 relative inline-block">
              <img src="/logo-light.png" alt="Logo" className="h-14 w-auto object-contain block dark:hidden" />
              <img src="/logo-dark.png" alt="Logo" className="h-14 w-auto object-contain hidden dark:block" />
            </div>
            <h1 className="text-3xl font-black text-foreground">Welcome back</h1>
            <p className="text-muted-foreground text-sm mt-1">Log in to track your progress</p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-1.5">
              <Label htmlFor="email" className="text-muted-foreground/80 text-xs font-semibold uppercase tracking-wider">
                Email
              </Label>
              <Input
                id="email"
                type="email"
                placeholder="you@example.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="bg-card border-border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl transition-all focus-visible:ring-2 focus-visible:ring-[var(--accent-primary)]/40 focus-visible:border-[var(--accent-primary)]"
              />
            </div>
            <div className="space-y-1.5">
              <div className="flex justify-between items-center">
                <Label htmlFor="password" className="text-muted-foreground/80 text-xs font-semibold uppercase tracking-wider">
                  Password
                </Label>
                <Link href="/forgot-password" className="text-xs font-semibold hover:underline text-[var(--accent-primary)]">
                  Forgot password?
                </Link>
              </div>
              <Input
                id="password"
                type="password"
                placeholder="••••••••"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                className="bg-card border-border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl transition-all focus-visible:ring-2 focus-visible:ring-[var(--accent-primary)]/40 focus-visible:border-[var(--accent-primary)]"
              />
            </div>

            {error && (
              <div className="text-sm text-red-500 bg-red-500/10 border border-red-500/20 px-4 py-3 rounded-xl flex flex-col gap-2">
                <span>{error}</span>
                {error.includes("verify your email") && (
                  <button
                    type="button"
                    onClick={handleResendVerification}
                    disabled={resendLoading}
                    className="text-left text-xs font-bold text-[var(--accent-primary)] underline hover:opacity-80 disabled:opacity-50 cursor-pointer"
                  >
                    {resendLoading ? "Resending..." : "Resend verification email"}
                  </button>
                )}
              </div>
            )}

            {resendMessage && (
              <div className="text-sm text-emerald-500 bg-emerald-500/10 border border-emerald-500/20 px-4 py-3 rounded-xl">
                {resendMessage}
              </div>
            )}

            <button
              type="submit"
              disabled={loading}
              className="relative w-full h-12 rounded-xl font-bold text-white dark:text-black bg-[var(--accent-primary)] hover:opacity-90 hover:scale-[1.02] disabled:opacity-50 disabled:cursor-not-allowed mt-2 transition-all cursor-pointer shadow-lg shadow-[rgba(var(--accent-primary-rgb),0.25)] overflow-hidden group"
            >
              <span className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-700" />
              <span className="relative">{loading ? "Logging in..." : "Log in"}</span>
            </button>
          </form>

          <div className="relative my-6">
            <div className="absolute inset-0 flex items-center">
              <span className="w-full border-t border-border/80" />
            </div>
            <div className="relative flex justify-center text-xs uppercase">
              <span className="bg-background px-2 text-muted-foreground">Or continue with</span>
            </div>
          </div>

          <button
            type="button"
            onClick={handleGithubLogin}
            className="w-full h-12 rounded-xl border border-border bg-card text-foreground font-bold hover:bg-muted/40 hover:border-foreground/20 transition-all flex items-center justify-center gap-2 cursor-pointer shadow-sm hover:shadow-md"
          >
            <GithubIcon className="w-5 h-5 text-foreground" />
            Continue with GitHub
          </button>

          <p className="text-center text-sm text-muted-foreground mt-6">
            Don&apos;t have an account?{" "}
            <Link href="/register" className="font-bold hover:text-foreground transition-colors text-[var(--accent-primary)]">
              Sign up
            </Link>
          </p>
        </div>
      </div>

      {/* Right Column */}
      <ShowcasePanel />
    </div>
  );
}

export default function LoginPage() {
  return (
    <Suspense
      fallback={
        <div className="min-h-[calc(100vh-64px)] flex items-center justify-center">
          <div className="text-muted-foreground animate-pulse text-sm">Loading login...</div>
        </div>
      }
    >
      <LoginContent />
    </Suspense>
  );
}