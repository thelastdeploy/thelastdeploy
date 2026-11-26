// web/frontend/app/login/page.tsx

"use client";

import { useState, Suspense } from "react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { OrganizationMembershipInfo } from "@/lib/types";
import { Building2, GraduationCap, Globe, ArrowRight, Check } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { GithubIcon, GoogleIcon } from "@/components/auth/brand-icons";
import { ShowcasePanel } from "@/components/auth/showcase-panel";
import { redirectToGithubOAuth, redirectToGoogleOAuth } from "@/lib/auth/oauth";

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
  const [availableOrgs, setAvailableOrgs] = useState<OrganizationMembershipInfo[] | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setResendMessage(null);
    setLoading(true);
    try {
      const { access_token, device_key } = await api.login(email, password);
      await login(access_token, device_key);

      // Check organization memberships
      try {
        const orgs = await api.getOrganizations();
        if (orgs && orgs.length > 1) {
          setAvailableOrgs(orgs);
          setLoading(false);
          return;
        } else if (orgs && orgs.length === 1) {
          api.setSelectedOrg(orgs[0].slug);
        } else {
          api.setSelectedOrg("tld");
        }
      } catch {
        api.setSelectedOrg("tld");
      }

      const redirect = searchParams.get("redirect") || "/dashboard";
      router.push(redirect);
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Login failed");
    } finally {
      setLoading(false);
    }
  };

  const handleSelectOrg = (slug: string) => {
    api.setSelectedOrg(slug);
    const redirect = searchParams.get("redirect") || "/dashboard";
    router.push(redirect);
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
    const res = redirectToGithubOAuth();
    if (!res.ok && res.error) setError(res.error);
  };

  const handleGoogleLogin = () => {
    const res = redirectToGoogleOAuth();
    if (!res.ok && res.error) setError(res.error);
  };

  if (availableOrgs && availableOrgs.length > 1) {
    return (
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center px-6 py-12 relative overflow-hidden">
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_70%_50%_at_50%_-20%,rgba(22,163,74,0.07),transparent)] dark:bg-[radial-gradient(ellipse_70%_50%_at_50%_-20%,rgba(22,163,74,0.04),transparent)]" />
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-96 h-48 bg-[var(--accent-primary)]/5 blur-3xl rounded-full pointer-events-none" />

        <div className="w-full max-w-lg relative z-10 space-y-6">
          <div className="text-center space-y-2">
            <div className="inline-flex items-center justify-center p-3.5 rounded-2xl bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] mb-2">
              <Building2 className="h-8 w-8" />
            </div>
            <h1 className="text-3xl font-black text-foreground">Select Workspace</h1>
            <p className="text-muted-foreground text-sm max-w-sm mx-auto">
              Your account belongs to multiple organizations. Choose which workspace you want to enter:
            </p>
          </div>

          <div className="space-y-3">
            {availableOrgs.map((org) => (
              <button
                key={org.slug}
                onClick={() => handleSelectOrg(org.slug)}
                className="w-full text-left p-4 rounded-2xl border border-border bg-card hover:border-[var(--accent-primary)] hover:shadow-lg transition-all flex items-center justify-between group cursor-pointer"
              >
                <div className="flex items-center gap-4">
                  <div className="h-12 w-12 rounded-xl bg-muted/60 flex items-center justify-center font-black group-hover:bg-[var(--accent-primary)]/10 group-hover:text-[var(--accent-primary)] transition-colors">
                    {org.type === "university" ? (
                      <GraduationCap className="h-6 w-6" />
                    ) : (org.type === "platform" || org.is_platform) ? (
                      <Globe className="h-6 w-6" />
                    ) : (
                      <Building2 className="h-6 w-6" />
                    )}
                  </div>
                  <div>
                    <div className="flex items-center gap-2">
                      <h3 className="font-bold text-foreground group-hover:text-[var(--accent-primary)] transition-colors">
                        {org.name}
                      </h3>
                      {(org.type === "platform" || org.is_platform) && (
                        <span className="text-[10px] uppercase font-mono px-2 py-0.5 rounded-full bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] font-bold">
                          Default
                        </span>
                      )}
                    </div>
                    <div className="flex items-center gap-2 mt-1 text-xs text-muted-foreground">
                      <span className="capitalize">{org.type}</span>
                      <span>•</span>
                      <span className="font-mono text-zinc-400 capitalize">
                        {org.roles && org.roles.length > 0 ? org.roles.join(", ") : "Learner"}
                      </span>
                      <span>•</span>
                      <span className="font-mono font-bold text-[var(--accent-primary)]">
                        {org.total_xp} XP
                      </span>
                    </div>
                  </div>
                </div>

                <div className="text-muted-foreground group-hover:text-[var(--accent-primary)] group-hover:translate-x-1 transition-all">
                  <ArrowRight className="h-5 w-5" />
                </div>
              </button>
            ))}
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-[calc(100vh-64px)] flex flex-col lg:flex-row transition-colors duration-300">
      {/* Left Column: Form */}
      <div className="flex-1 flex items-center justify-center px-6 py-12 relative overflow-hidden">
        {/* Light mode background */}
        <div className="absolute inset-0 bg-gradient-to-br from-slate-50 via-white to-slate-100 dark:from-transparent dark:via-transparent dark:to-transparent" />
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_70%_50%_at_50%_-20%,rgba(22,163,74,0.07),transparent)] dark:bg-[radial-gradient(ellipse_70%_50%_at_50%_-20%,rgba(22,163,74,0.04),transparent)]" />
        {/* Subtle dot grid for light mode */}
        <div className="absolute inset-0 opacity-[0.03] dark:opacity-0 bg-[radial-gradient(circle,#0f172a_1px,transparent_1px)] bg-[size:24px_24px]" />
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
                className="bg-muted/60 dark:bg-card border-border dark:border-border border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl transition-all focus-visible:ring-2 focus-visible:ring-[var(--accent-primary)]/40 focus-visible:border-[var(--accent-primary)] shadow-sm"
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
                className="bg-muted/60 dark:bg-card border-border dark:border-border border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl transition-all focus-visible:ring-2 focus-visible:ring-[var(--accent-primary)]/40 focus-visible:border-[var(--accent-primary)] shadow-sm"
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

          <div className="flex flex-col gap-3">
            <button
              type="button"
              id="github-login-btn"
              onClick={handleGithubLogin}
              className="w-full h-12 rounded-xl border border-border/80 dark:border-border bg-white dark:bg-card text-foreground font-bold hover:bg-muted/50 dark:hover:bg-muted/40 hover:border-foreground/30 dark:hover:border-foreground/20 transition-all flex items-center justify-center gap-2 cursor-pointer shadow-sm hover:shadow-md"
            >
              <GithubIcon className="w-5 h-5 text-foreground" />
              Continue with GitHub
            </button>

            <button
              type="button"
              id="google-login-btn"
              onClick={handleGoogleLogin}
              className="w-full h-12 rounded-xl border border-border/80 dark:border-border bg-white dark:bg-card text-foreground font-bold hover:bg-muted/50 dark:hover:bg-muted/40 hover:border-foreground/30 dark:hover:border-foreground/20 transition-all flex items-center justify-center gap-2 cursor-pointer shadow-sm hover:shadow-md"
            >
              <GoogleIcon className="w-5 h-5" />
              Continue with Google
            </button>
          </div>

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