// web/frontend/app/login/page.tsx

"use client";

import { useState, Suspense } from "react";
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
      
      // Handle redirect parameter if present
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
      {/* Left Column: Input Form */}
      <div className="flex-1 flex items-center justify-center px-6 py-12">
        <div className="w-full max-w-sm">
          <div className="mb-8">
            <div className="mb-5">
              <img
                src="/logo-light.png"
                alt="Logo"
                className="h-14 w-auto object-contain block dark:hidden"
              />
              <img
                src="/logo-dark.png"
                alt="Logo"
                className="h-14 w-auto object-contain hidden dark:block"
              />
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
                className="bg-card border-border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl focus:border-[var(--accent-primary)] focus:ring-0"
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
                className="bg-card border-border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl focus:border-[var(--accent-primary)] focus:ring-0"
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
              className="w-full h-12 rounded-xl font-bold text-background bg-[var(--accent-primary)] hover:opacity-90 hover:scale-[1.02] disabled:opacity-50 disabled:cursor-not-allowed mt-2 transition-all text-white dark:text-black cursor-pointer shadow-sm shadow-[rgba(var(--accent-primary-rgb),0.1)]"
            >
              {loading ? "Logging in..." : "Log in"}
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
            className="w-full h-12 rounded-xl border border-border bg-card text-foreground font-bold hover:bg-muted/40 transition-all flex items-center justify-center gap-2 cursor-pointer shadow-sm"
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

      {/* Right Column: Premium Showcase Panel */}
      <div className="hidden lg:flex flex-1 bg-muted/10 relative items-center justify-center p-12 border-l border-border/50 overflow-hidden">
        {/* Decorative Grid & Glow */}
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,rgba(var(--accent-primary-rgb),0.05),transparent_60%)]" />
        <div className="absolute inset-0 bg-[linear-gradient(rgba(255,255,255,0.005)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.005)_1px,transparent_1px)] bg-[size:30px_30px]" />

        <div className="max-w-md w-full space-y-8 text-center relative z-10">
          {/* Card Mockup */}
          <div className="bg-card border border-border p-6 rounded-2xl shadow-2xl space-y-6 text-left transform hover:-translate-y-1 transition-all duration-500 relative">
            <div className="absolute -top-3 -right-3 w-8 h-8 rounded-full bg-emerald-500/10 border border-emerald-500/30 flex items-center justify-center text-emerald-400 font-bold text-xs">
              ⚡
            </div>

            <div className="flex items-center justify-between border-b border-border pb-4">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-[var(--accent-primary)]/10 flex items-center justify-center text-[var(--accent-primary)] border border-[var(--accent-primary)]/20 font-black">
                  D
                </div>
                <div>
                  <h3 className="font-black text-foreground text-sm tracking-wide">Docker Storage</h3>
                  <p className="text-[10px] text-muted-foreground">Volume Persist & Backups</p>
                </div>
              </div>

              {/* Progress Ring */}
              <div className="relative w-12 h-12 flex items-center justify-center select-none">
                <svg className="w-full h-full transform -rotate-90">
                  <circle cx="24" cy="24" r="18" stroke="currentColor" strokeWidth="3" className="text-border" fill="transparent" />
                  <circle cx="24" cy="24" r="18" stroke="currentColor" strokeWidth="3" className="text-[var(--accent-primary)]" fill="transparent" strokeDasharray={113} strokeDashoffset={22} />
                </svg>
                <span className="absolute text-[10px] font-black text-foreground">80%</span>
              </div>
            </div>

            {/* Terminal Mock Window */}
            <div className="bg-background border border-border rounded-xl p-4 font-mono text-xs text-muted-foreground/80 space-y-1.5 shadow-inner select-none">
              <div className="flex items-center gap-1.5 border-b border-border/40 pb-2 mb-2">
                <span className="w-2 h-2 rounded-full bg-red-500/80" />
                <span className="w-2 h-2 rounded-full bg-yellow-500/80" />
                <span className="w-2 h-2 rounded-full bg-green-500/80" />
                <span className="text-[10px] text-muted-foreground/50 ml-1">tld check</span>
              </div>
              <p className="text-[var(--accent-primary)]">$ tld check dkr-backup-volume</p>
              <p className="text-emerald-400/90">✓ Found named volume prod-db-vol</p>
              <p className="text-emerald-400/90">✓ Asserted backup file backup.tar exists</p>
              <p className="text-foreground animate-pulse mt-1">✓ Lab passed! +20 XP awarded</p>
            </div>
          </div>

          <div className="space-y-2">
            <h2 className="text-2xl font-black text-foreground tracking-tight">Master DevOps & Automation</h2>
            <p className="text-muted-foreground text-sm leading-relaxed max-w-sm mx-auto">
              Practice real-world deployment challenges inside your local terminal. Build production-level infrastructure safely.
            </p>
          </div>
        </div>
      </div>
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