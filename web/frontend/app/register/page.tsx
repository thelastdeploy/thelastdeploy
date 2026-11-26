// web/frontend/app/register/page.tsx

"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { api } from "@/lib/api";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { GithubIcon, GoogleIcon } from "@/components/auth/brand-icons";
import { JourneyPanel } from "@/components/auth/journey-panel";
import { redirectToGithubOAuth, redirectToGoogleOAuth, isDevEnvironment } from "@/lib/auth/oauth";

const CheckCircleIcon = (props: React.SVGProps<SVGSVGElement>) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" {...props}>
    <circle cx="12" cy="12" r="10" />
    <path d="m9 12 2 2 4-4" />
  </svg>
);

const XCircleIcon = (props: React.SVGProps<SVGSVGElement>) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" {...props}>
    <circle cx="12" cy="12" r="10" />
    <path d="m15 9-6 6" />
    <path d="m9 9 6 6" />
  </svg>
);

export default function RegisterPage() {
  const [email, setEmail] = useState("");
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [isRegistered, setIsRegistered] = useState(false);

  const [registrationDetail, setRegistrationDetail] = useState<string | null>(null);
  const isDevEnv = isDevEnvironment();

  // Username checking states
  const [isCheckingUsername, setIsCheckingUsername] = useState(false);
  const [usernameAvailable, setUsernameAvailable] = useState<boolean | null>(null);
  const [usernameMessage, setUsernameMessage] = useState<string | null>(null);

  useEffect(() => {
    if (!username) {
      setUsernameAvailable(null);
      setUsernameMessage(null);
      setIsCheckingUsername(false);
      return;
    }

    if (username.length < 3) {
      setUsernameAvailable(false);
      setUsernameMessage("Username must be at least 3 characters");
      setIsCheckingUsername(false);
      return;
    }

    setIsCheckingUsername(true);
    setUsernameMessage(null);

    const timer = setTimeout(async () => {
      try {
        const res = await api.checkUsername(username);
        if (res.available) {
          setUsernameAvailable(true);
          setUsernameMessage("Username is available!");
        } else {
          setUsernameAvailable(false);
          setUsernameMessage(res.detail || "Username is already taken");
        }
      } catch (err) {
        setUsernameAvailable(null);
        setUsernameMessage("Could not verify username availability");
      } finally {
        setIsCheckingUsername(false);
      }
    }, 500);

    return () => clearTimeout(timer);
  }, [username]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    if (usernameAvailable === false) {
      setError("Please choose an available username.");
      return;
    }

    setLoading(true);
    try {
      const res = await api.register(email, username, password);
      setRegistrationDetail(res.detail);
      setIsRegistered(true);
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Registration failed");
    } finally {
      setLoading(false);
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

  return (
    <div className="min-h-[calc(100vh-64px)] flex flex-col lg:flex-row transition-colors duration-300">
      {/* Left Column: Form */}
      <div className="flex-1 flex items-center justify-center px-6 py-12 relative overflow-hidden">
        {/* Light mode background */}
        <div className="absolute inset-0 bg-gradient-to-br from-slate-50 via-white to-slate-100 dark:from-transparent dark:via-transparent dark:to-transparent" />
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_70%_50%_at_50%_-20%,rgba(168,85,247,0.06),transparent)] dark:bg-[radial-gradient(ellipse_70%_50%_at_50%_-20%,rgba(168,85,247,0.03),transparent)]" />
        {/* Subtle dot grid for light mode */}
        <div className="absolute inset-0 opacity-[0.03] dark:opacity-0 bg-[radial-gradient(circle,#0f172a_1px,transparent_1px)] bg-[size:24px_24px]" />
        {/* Subtle bg glow behind logo */}
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-64 h-32 bg-purple-500/5 blur-3xl rounded-full pointer-events-none" />

        <div className="w-full max-w-sm relative z-10">
          {isRegistered ? (
            <div className="space-y-6 text-center">
              <div className="w-16 h-16 mx-auto rounded-2xl bg-emerald-500/10 flex items-center justify-center border border-emerald-500/20 text-emerald-500">
                <CheckCircleIcon className="w-8 h-8" />
              </div>
              <div className="space-y-2">
                <h1 className="text-2xl font-black text-foreground">
                  {registrationDetail?.includes("skipped") || isDevEnv
                    ? "Account Created!"
                    : "Check your email"}
                </h1>
                <p className="text-muted-foreground text-sm leading-relaxed">
                  {registrationDetail?.includes("skipped") || isDevEnv ? (
                    <>
                      Account created for <span className="font-bold text-foreground">{email}</span>. Email verification is skipped in development mode. You can log in directly.
                    </>
                  ) : (
                    <>
                      We&apos;ve sent a verification link to <span className="font-bold text-foreground">{email}</span>. Please click the link in the email to activate your account.
                    </>
                  )}
                </p>
              </div>
              <Link
                href="/login"
                className="inline-block w-full h-12 leading-[48px] rounded-xl font-bold bg-[var(--accent-primary)] hover:opacity-90 transition-all text-white shadow-sm"
              >
                Go to Log in
              </Link>
            </div>
          ) : (
            <>
              <div className="mb-8">
                <div className="mb-5">
                  <img src="/logo-light.png" alt="Logo" className="h-14 w-auto object-contain block dark:hidden" />
                  <img src="/logo-dark.png" alt="Logo" className="h-14 w-auto object-contain hidden dark:block" />
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
                    placeholder="devops_ninja"
                    value={username}
                    onChange={(e) => setUsername(e.target.value)}
                    required
                    className="bg-muted/60 dark:bg-card border-border dark:border-border border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl transition-all focus-visible:ring-2 focus-visible:ring-[var(--accent-primary)]/40 focus-visible:border-[var(--accent-primary)] shadow-sm"
                  />
                  {username && (
                    <div className="text-xs mt-1.5 flex items-center gap-1.5 px-1 min-h-[16px]">
                      {isCheckingUsername ? (
                        <span className="text-muted-foreground animate-pulse">Checking availability...</span>
                      ) : usernameAvailable === true ? (
                        <span className="text-emerald-500 font-medium flex items-center gap-1"><CheckCircleIcon className="w-3.5 h-3.5" />{usernameMessage}</span>
                      ) : usernameAvailable === false ? (
                        <span className="text-red-500 font-medium flex items-center gap-1"><XCircleIcon className="w-3.5 h-3.5" />{usernameMessage}</span>
                      ) : null}
                    </div>
                  )}
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
                    className="bg-muted/60 dark:bg-card border-border dark:border-border border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl transition-all focus-visible:ring-2 focus-visible:ring-[var(--accent-primary)]/40 focus-visible:border-[var(--accent-primary)] shadow-sm"
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
                    className="bg-muted/60 dark:bg-card border-border dark:border-border border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl transition-all focus-visible:ring-2 focus-visible:ring-[var(--accent-primary)]/40 focus-visible:border-[var(--accent-primary)] shadow-sm"
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
                  className="relative w-full h-12 rounded-xl font-bold text-white dark:text-black bg-[var(--accent-primary)] hover:opacity-90 hover:scale-[1.02] disabled:opacity-50 disabled:cursor-not-allowed mt-2 transition-all cursor-pointer shadow-lg shadow-[rgba(var(--accent-primary-rgb),0.25)] overflow-hidden group"
                >
                  <span className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-700" />
                  <span className="relative">{loading ? "Creating account..." : "Create account"}</span>
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
                  id="github-register-btn"
                  onClick={handleGithubLogin}
                  className="w-full h-12 rounded-xl border border-border/80 dark:border-border bg-white dark:bg-card text-foreground font-bold hover:bg-muted/50 dark:hover:bg-muted/40 hover:border-foreground/30 dark:hover:border-foreground/20 transition-all flex items-center justify-center gap-2 cursor-pointer shadow-sm hover:shadow-md"
                >
                  <GithubIcon className="w-5 h-5 text-foreground" />
                  Continue with GitHub
                </button>

                <button
                  type="button"
                  id="google-register-btn"
                  onClick={handleGoogleLogin}
                  className="w-full h-12 rounded-xl border border-border/80 dark:border-border bg-white dark:bg-card text-foreground font-bold hover:bg-muted/50 dark:hover:bg-muted/40 hover:border-foreground/30 dark:hover:border-foreground/20 transition-all flex items-center justify-center gap-2 cursor-pointer shadow-sm hover:shadow-md"
                >
                  <GoogleIcon className="w-5 h-5" />
                  Continue with Google
                </button>
              </div>

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

      {/* Right Column */}
      <JourneyPanel />
    </div>
  );
}