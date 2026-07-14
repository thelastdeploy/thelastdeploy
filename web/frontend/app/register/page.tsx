// web/frontend/app/register/page.tsx

"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { api } from "@/lib/api";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

const GithubIcon = (props: React.SVGProps<SVGSVGElement>) => (
  <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round" {...props}>
    <path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22" />
  </svg>
);

const DockerIcon = () => (
  <svg viewBox="0 0 24 24" width="22" height="22" fill="currentColor">
    <path d="M13.983 11.078h2.119a.186.186 0 00.186-.185V9.006a.186.186 0 00-.186-.186h-2.119a.185.185 0 00-.185.185v1.888c0 .102.083.185.185.185m-2.954-5.43h2.118a.186.186 0 00.186-.186V3.574a.186.186 0 00-.186-.185h-2.118a.185.185 0 00-.185.185v1.888c0 .102.082.185.185.185m0 2.716h2.118a.187.187 0 00.186-.186V6.29a.186.186 0 00-.186-.185h-2.118a.185.185 0 00-.185.185v1.887c0 .102.082.185.185.186m-2.93 0h2.12a.186.186 0 00.184-.186V6.29a.185.185 0 00-.185-.185H8.1a.185.185 0 00-.185.185v1.887c0 .102.083.185.185.186m-2.964 0h2.119a.186.186 0 00.185-.186V6.29a.185.185 0 00-.185-.185H5.136a.186.186 0 00-.186.185v1.887c0 .102.084.185.186.186m5.893 2.715h2.118a.186.186 0 00.186-.185V9.006a.186.186 0 00-.186-.186h-2.118a.185.185 0 00-.185.185v1.888c0 .102.082.185.185.185m-2.93 0h2.12a.185.185 0 00.184-.185V9.006a.185.185 0 00-.184-.186h-2.12a.185.185 0 00-.184.185v1.888c0 .102.083.185.185.185m-2.964 0h2.119a.185.185 0 00.185-.185V9.006a.185.185 0 00-.184-.186h-2.12a.186.186 0 00-.186.186v1.887c0 .102.084.185.186.185m-2.92 0h2.12a.186.186 0 00.184-.185V9.006a.185.185 0 00-.184-.186h-2.12a.185.185 0 00-.184.186v1.887c0 .102.082.185.185.185M23.763 9.89c-.065-.051-.672-.51-1.954-.51-.338.001-.676.03-1.01.087-.248-1.7-1.653-2.53-1.716-2.566l-.344-.199-.226.327c-.284.438-.49.922-.612 1.43-.23.97-.09 1.882.403 2.661-.595.332-1.55.413-1.744.42H.751a.751.751 0 00-.75.748 11.376 11.376 0 00.692 4.062c.545 1.428 1.355 2.48 2.41 3.124 1.18.723 3.1 1.137 5.275 1.137.983.003 1.963-.086 2.93-.266a12.248 12.248 0 003.823-1.389c.98-.567 1.86-1.288 2.61-2.136 1.252-1.418 1.998-2.997 2.553-4.4h.221c1.372 0 2.215-.549 2.68-1.009.309-.293.55-.65.707-1.046l.098-.288Z" />
  </svg>
);

const K8sIcon = () => (
  <svg viewBox="0 0 24 24" width="22" height="22" fill="currentColor">
    <path d="M10.204 14.35l.007.01-.999 2.413a5.171 5.171 0 01-2.075-2.597l2.578-.437.004.005.485.606zm-.833-2.129l-.002-.002-2.574-.441a5.187 5.187 0 01.586-2.937l2.127 1.547-.001.003-.136 1.83zm2.707-2.61l.001.002-1.077-2.329c.76-.282 1.58-.43 2.423-.43.63 0 1.24.09 1.82.256l-1.064 2.33-.002-.001-2.101.172zm2.883 2.607l-.001-.002-.138-1.831 2.128-1.547a5.153 5.153 0 01.586 2.937l-2.575.443zm-.485 1.04l.004-.006 2.577.437a5.17 5.17 0 01-2.074 2.597l-1-2.413.007-.01-.514-.605zM12 15.056l.002.003-1.216 2.188a5.15 5.15 0 002.428 0L12.003 15.06 12 15.056zm.001-10.05C6.477 5.006 2 9.483 2 15.006s4.477 10.001 10 10.001 10-4.478 10-10.001c0-5.523-4.477-10-10-10z" />
  </svg>
);

const LinuxIcon = () => (
  <svg viewBox="0 0 24 24" width="22" height="22" fill="currentColor">
    <path d="M12.504 0c-.155 0-.315.008-.48.021-4.226.333-3.105 4.807-3.17 6.298-.076 1.092-.3 1.953-1.05 3.02-.885 1.051-2.127 2.75-2.716 4.521-.278.832-.41 1.684-.287 2.489a.424.424 0 00-.11.135c-.26.268-.45.6-.663.839-.199.199-.485.267-.797.4-.313.136-.658.269-.864.68-.09.189-.136.394-.132.602 0 .199.027.4.055.536.058.399.116.728.04.97-.249.68-.28 1.145-.106 1.484.174.334.535.47.94.601.78.24 1.76.057 2.375.47.595.412.767 1.763 1.6 1.963.664.166 1.14-.468 1.64-.835.5-.368 1.29-.8 2.81-.42.88.215 1.452.394 1.956.394.503 0 .875-.179 1.372-.962.495-.784.756-1.804 1.147-2.219.43-.443 1.024-.513 1.528-.855.505-.34.899-.904.965-1.498.014-.097.02-.196.02-.294 0-.508-.173-.928-.558-1.23-.389-.295-1.013-.42-1.734-.4-.12.003-.215.01-.296.02h-.006c-.01-.086-.019-.175-.024-.267-.128-2.12-.682-5.018-2.168-6.58-1.47-1.542-4.133-1.81-5.744-.17-.786.793-1.207 1.852-1.457 2.965-.248 1.11-.292 2.282-.19 3.317.102 1.036.366 1.894.782 2.379.42.484.975.643 1.568.643.21 0 .423-.024.634-.073.42-.1.833-.306 1.2-.606-.21.213-.372.508-.434.857-.063.35-.033.73.06 1.066.185.67.6 1.126.967 1.354.369.23.717.25 1.007.076a1.06 1.06 0 00.48-.742c.065-.415-.025-.847-.113-1.168-.088-.32-.176-.527-.153-.608a1.21 1.21 0 01.018-.077c.3-.178.695-.267 1.09-.353.395-.086.79-.17 1.124-.353.67-.371 1.117-1.122 1.18-1.921a3.255 3.255 0 00-.096-.999 3.39 3.39 0 00-.38-.97 3.457 3.457 0 00-.62-.766c.07-.254.117-.52.133-.796.04-.736-.08-1.47-.366-2.14-.284-.668-.747-1.265-1.374-1.734-.628-.47-1.407-.766-2.234-.87C13.088.025 12.796 0 12.504 0z" />
  </svg>
);

const steps = [
  {
    num: 1,
    label: "Create Account",
    desc: "Join free, no credit card",
    done: true,
    color: "#16a34a",
  },
  {
    num: 2,
    label: "Pick a Track",
    desc: "Docker, K8s, Linux or Git",
    done: false,
    color: "#3b82f6",
  },
  {
    num: 3,
    label: "Run First Lab",
    desc: "In your local terminal",
    done: false,
    color: "#a855f7",
  },
];

function JourneyPanel() {
  const icons = [
    { Icon: DockerIcon, color: "#3b82f6", label: "Docker", angle: 0 },
    { Icon: K8sIcon, color: "#a855f7", label: "K8s", angle: 120 },
    { Icon: LinuxIcon, color: "#f59e0b", label: "Linux", angle: 240 },
  ];

  return (
    <div className="hidden lg:flex flex-1 relative items-center justify-center p-12 overflow-hidden border-l border-white/[0.06]">
      {/* Dark bg */}
      <div className="absolute inset-0 bg-[#0a0a0f]" />
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_60%_50%_at_30%_50%,rgba(168,85,247,0.10),transparent)]" />
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_40%_40%_at_80%_20%,rgba(22,163,74,0.09),transparent)]" />
      {/* Grid */}
      <div className="absolute inset-0 bg-[linear-gradient(rgba(255,255,255,0.025)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.025)_1px,transparent_1px)] bg-[size:40px_40px]" />

      {/* Glow blobs */}
      <div className="absolute top-20 left-20 w-36 h-36 rounded-full bg-purple-500/10 blur-3xl animate-pulse" />
      <div className="absolute bottom-20 right-16 w-28 h-28 rounded-full bg-[var(--accent-primary)]/10 blur-3xl animate-pulse" style={{ animationDelay: "1.5s" }} />

      {/* Free badge */}
      <div
        className="absolute top-8 left-8 flex items-center gap-2 bg-white/5 border border-white/10 backdrop-blur-sm rounded-xl px-3.5 py-2 shadow-lg"
        style={{ animation: "floatBadge 3.5s ease-in-out infinite" }}
      >
        <span className="text-base">🎁</span>
        <p className="text-[11px] font-bold text-white/80">Free Forever · No CC Required</p>
      </div>

      <div className="max-w-md w-full space-y-6 relative z-10">
        {/* Orbiting icons orb */}
        <div className="flex justify-center">
          <div className="relative w-48 h-48">
            {/* Center orb */}
            <div className="absolute inset-0 flex items-center justify-center">
              <div className="w-16 h-16 rounded-2xl bg-[var(--accent-primary)]/20 border border-[var(--accent-primary)]/40 flex items-center justify-center shadow-lg shadow-[rgba(22,163,74,0.2)]" style={{ animation: "pulseOrb 2s ease-in-out infinite" }}>
                <span className="text-2xl">🚀</span>
              </div>
            </div>
            {/* Orbit ring */}
            <div className="absolute inset-4 rounded-full border border-white/[0.07]" style={{ animation: "spinOrbit 12s linear infinite" }}>
              {icons.map(({ Icon, color, label }, i) => {
                const angle = (i * 120 - 90) * (Math.PI / 180);
                const r = 68;
                const x = 50 + r * Math.cos(angle);
                const y = 50 + r * Math.sin(angle);
                return (
                  <div
                    key={label}
                    className="absolute w-10 h-10 rounded-xl flex items-center justify-center border"
                    style={{
                      left: `calc(${x}% - 20px)`,
                      top: `calc(${y}% - 20px)`,
                      background: `${color}18`,
                      borderColor: `${color}40`,
                      color,
                      animation: `spinOrbitCounter 12s linear infinite`,
                    }}
                  >
                    <Icon />
                  </div>
                );
              })}
            </div>
          </div>
        </div>

        {/* Journey steps */}
        <div className="bg-white/[0.04] border border-white/10 rounded-2xl p-6 backdrop-blur-sm space-y-5">
          <p className="text-white/40 text-[11px] uppercase tracking-widest font-semibold">Your Journey</p>
          <div className="space-y-1">
            {steps.map((step, idx) => (
              <div key={step.num} className="relative">
                <div className="flex items-start gap-4">
                  {/* Step number / check */}
                  <div
                    className="w-8 h-8 rounded-full flex items-center justify-center text-xs font-black shrink-0 border"
                    style={
                      step.done
                        ? { background: `${step.color}25`, borderColor: `${step.color}50`, color: step.color }
                        : { background: "rgba(255,255,255,0.04)", borderColor: "rgba(255,255,255,0.1)", color: "rgba(255,255,255,0.3)" }
                    }
                  >
                    {step.done ? "✓" : step.num}
                  </div>
                  {/* Label */}
                  <div className="pt-0.5 pb-4">
                    <p className={`text-sm font-bold ${step.done ? "text-white/90" : "text-white/40"}`}>{step.label}</p>
                    <p className="text-[11px] text-white/30 mt-0.5">{step.desc}</p>
                  </div>
                </div>
                {/* Connector line */}
                {idx < steps.length - 1 && (
                  <div className="absolute left-4 top-8 w-px h-[calc(100%-8px)] bg-white/[0.07]" />
                )}
              </div>
            ))}
          </div>
        </div>

        {/* Caption */}
        <div className="text-center space-y-1 pt-1">
          <h2 className="text-white font-black text-xl tracking-tight">Build Cloud Native Systems</h2>
          <p className="text-white/40 text-sm leading-relaxed">
            Learn by doing. No fluff. Just real labs.
          </p>
        </div>
      </div>
    </div>
  );
}

export default function RegisterPage() {
  const [email, setEmail] = useState("");
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [isRegistered, setIsRegistered] = useState(false);

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
      await api.register(email, username, password);
      setIsRegistered(true);
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Registration failed");
    } finally {
      setLoading(false);
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
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-64 h-32 bg-purple-500/5 blur-3xl rounded-full pointer-events-none" />

        <div className="w-full max-w-sm relative z-10">
          {isRegistered ? (
            <div className="space-y-6 text-center">
              <div className="w-16 h-16 mx-auto rounded-2xl bg-emerald-500/10 flex items-center justify-center border border-emerald-500/20 text-emerald-500 animate-bounce">
                <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M3 19v-8.93a2 2 0 01.89-1.664l8-5.333a2 2 0 012.22 0l8 5.333A2 2 0 0121 10.07V19M3 19a2 2 0 002 2h14a2 2 0 002-2M3 19l6.75-4.5M21 19l-6.75-4.5M3 10l6.75 4.5M21 10l-6.75 4.5m0 0l-2.25-1.5a2 2 0 00-2.22 0l-2.25 1.5" />
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
                    className="bg-card border-border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl transition-all focus-visible:ring-2 focus-visible:ring-[var(--accent-primary)]/40 focus-visible:border-[var(--accent-primary)]"
                  />
                  {username && (
                    <div className="text-xs mt-1.5 flex items-center gap-1.5 px-1 min-h-[16px]">
                      {isCheckingUsername ? (
                        <span className="text-muted-foreground animate-pulse">Checking availability...</span>
                      ) : usernameAvailable === true ? (
                        <span className="text-emerald-500 font-medium">✓ {usernameMessage}</span>
                      ) : usernameAvailable === false ? (
                        <span className="text-red-500 font-medium">✗ {usernameMessage}</span>
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
                    className="bg-card border-border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl transition-all focus-visible:ring-2 focus-visible:ring-[var(--accent-primary)]/40 focus-visible:border-[var(--accent-primary)]"
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
                    className="bg-card border-border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl transition-all focus-visible:ring-2 focus-visible:ring-[var(--accent-primary)]/40 focus-visible:border-[var(--accent-primary)]"
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

              <button
                type="button"
                onClick={handleGithubLogin}
                className="w-full h-12 rounded-xl border border-border bg-card text-foreground font-bold hover:bg-muted/40 hover:border-foreground/20 transition-all flex items-center justify-center gap-2 cursor-pointer shadow-sm hover:shadow-md"
              >
                <GithubIcon className="w-5 h-5 text-foreground" />
                Continue with GitHub
              </button>

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