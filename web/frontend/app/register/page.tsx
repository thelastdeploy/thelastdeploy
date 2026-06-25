// web/frontend/app/register/page.tsx

"use client";

import { useState } from "react";
import Link from "next/link";
import { api } from "@/lib/api";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

export default function RegisterPage() {
  const [email, setEmail] = useState("");
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [isRegistered, setIsRegistered] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);
    try {
      await api.register(email, username, password);
      setIsRegistered(true);
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Registration failed");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-[calc(100vh-64px)] flex flex-col lg:flex-row transition-colors duration-300">
      {/* Left Column: Input Form / Success Card */}
      <div className="flex-1 flex items-center justify-center px-6 py-12">
        <div className="w-full max-w-sm">
          {isRegistered ? (
            <div className="space-y-6 text-center">
              <div className="w-16 h-16 mx-auto rounded-2xl bg-emerald-500/10 flex items-center justify-center border border-emerald-500/20 text-emerald-500 animate-bounce">
                <svg
                  className="w-8 h-8"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2.5}
                    d="M3 19v-8.93a2 2 0 01.89-1.664l8-5.333a2 2 0 012.22 0l8 5.333A2 2 0 0121 10.07V19M3 19a2 2 0 002 2h14a2 2 0 002-2M3 19l6.75-4.5M21 19l-6.75-4.5M3 10l6.75 4.5M21 10l-6.75 4.5m0 0l-2.25-1.5a2 2 0 00-2.22 0l-2.25 1.5"
                  />
                </svg>
              </div>
              <div className="space-y-2">
                <h1 className="text-2xl font-black text-foreground">Check your email</h1>
                <p className="text-muted-foreground text-sm leading-relaxed">
                  We&apos;ve sent a verification link to <span className="font-bold text-foreground">{email}</span>.
                </p>
                <p className="text-muted-foreground text-xs">
                  Please click the link in the email to activate your account.
                </p>
              </div>
              <Link
                href="/login"
                className="inline-block w-full h-12 leading-[48px] rounded-xl font-bold text-background bg-[var(--accent-primary)] hover:opacity-90 transition-all text-white dark:text-black shadow-sm"
              >
                Go to Log in
              </Link>
            </div>
          ) : (
            <>
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
                <h1 className="text-3xl font-black text-foreground">Create account</h1>
                <p className="text-muted-foreground text-sm mt-1">Free forever. No credit card needed.</p>
              </div>

              <form onSubmit={handleSubmit} className="space-y-4">
                <div className="space-y-1.5">
                  <Label htmlFor="username" className="text-muted-foreground/80 text-xs font-semibold uppercase tracking-wider">
                    Username
                  </Label>
                  <Input
                    id="username"
                    type="text"
                    placeholder="fsociety"
                    value={username}
                    onChange={(e) => setUsername(e.target.value)}
                    required
                    className="bg-card border-border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl focus:border-[var(--accent-primary)] focus:ring-0"
                  />
                </div>
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
                  <Label htmlFor="password" className="text-muted-foreground/80 text-xs font-semibold uppercase tracking-wider">
                    Password
                  </Label>
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
                  <div className="text-sm text-red-500 bg-red-500/10 border border-red-500/20 px-4 py-3 rounded-xl">
                    {error}
                  </div>
                )}

                <button
                  type="submit"
                  disabled={loading}
                  className="w-full h-12 rounded-xl font-bold text-background bg-[var(--accent-primary)] hover:opacity-90 hover:scale-[1.02] disabled:opacity-50 disabled:cursor-not-allowed mt-2 transition-all text-white dark:text-black cursor-pointer shadow-sm shadow-[rgba(var(--accent-primary-rgb),0.1)]"
                >
                  {loading ? "Creating account..." : "Create account"}
                </button>
              </form>

              <p className="text-center text-sm text-muted-foreground mt-6">
                Already have an account?{" "}
                <Link href="/login" className="font-bold hover:text-foreground transition-colors text-[var(--accent-primary)]">
                  Log in
                </Link>
              </p>
            </>
          )}
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
            <div className="absolute -top-3 -right-3 w-8 h-8 rounded-full bg-emerald-500/10 border border-emerald-500/30 flex items-center justify-center text-emerald-400 font-bold text-xs animate-pulse">
              ☸️
            </div>

            <div className="flex items-center justify-between border-b border-border pb-4">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-indigo-500/10 flex items-center justify-center text-indigo-400 border border-indigo-500/20 font-black">
                  K
                </div>
                <div>
                  <h3 className="font-black text-foreground text-sm tracking-wide">Kubernetes Sync</h3>
                  <p className="text-[10px] text-muted-foreground">Auto Scaling & Health Checks</p>
                </div>
              </div>

              {/* Progress Ring */}
              <div className="relative w-12 h-12 flex items-center justify-center select-none">
                <svg className="w-full h-full transform -rotate-90">
                  <circle cx="24" cy="24" r="18" stroke="currentColor" strokeWidth="3" className="text-border" fill="transparent" />
                  <circle cx="24" cy="24" r="18" stroke="currentColor" strokeWidth="3" className="text-indigo-400" fill="transparent" strokeDasharray={113} strokeDashoffset={9} />
                </svg>
                <span className="absolute text-[10px] font-black text-foreground">92%</span>
              </div>
            </div>

            {/* Terminal Mock Window */}
            <div className="bg-background border border-border rounded-xl p-4 font-mono text-xs text-muted-foreground/80 space-y-1.5 shadow-inner select-none">
              <div className="flex items-center gap-1.5 border-b border-border/40 pb-2 mb-2">
                <span className="w-2 h-2 rounded-full bg-red-500/80" />
                <span className="w-2 h-2 rounded-full bg-yellow-500/80" />
                <span className="w-2 h-2 rounded-full bg-green-500/80" />
                <span className="text-[10px] text-muted-foreground/50 ml-1">tld run</span>
              </div>
              <p className="text-[var(--accent-primary)]">$ tld check k8s-pod-status</p>
              <p className="text-emerald-400/90">✓ Running: pod/web-app-7f4c9c7b-2k9jx</p>
              <p className="text-emerald-400/90">✓ Connected: service/web-app-svc</p>
              <p className="text-emerald-400/90">✓ Verified: Ingress routing rules applied</p>
              <p className="text-foreground animate-pulse mt-1">✓ Lab passed! +25 XP awarded</p>
            </div>
          </div>

          <div className="space-y-2">
            <h2 className="text-2xl font-black text-foreground tracking-tight">Build Cloud Native Systems</h2>
            <p className="text-muted-foreground text-sm leading-relaxed max-w-sm mx-auto">
              Learn Kubernetes, Docker, and Linux by running interactive tasks directly inside your local environment.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}