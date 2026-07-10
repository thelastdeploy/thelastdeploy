"use client";

import { useEffect, useState, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import Link from "next/link";

function CallbackContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const { login } = useAuth();
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const code = searchParams.get("code");
    if (!code) {
      setError("No authorization code provided from GitHub.");
      return;
    }

    let isMounted = true;

    async function authenticate(authCode: string) {
      try {
        const { access_token, device_key } = await api.loginWithGitHub(authCode);
        if (isMounted) {
          await login(access_token, device_key);
          router.push("/dashboard");
        }
      } catch (err: unknown) {
        if (isMounted) {
          setError(err instanceof Error ? err.message : "GitHub authentication failed");
        }
      }
    }

    authenticate(code);

    return () => {
      isMounted = false;
    };
  }, [searchParams, login, router]);

  if (error) {
    return (
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center p-6 bg-background">
        <div className="w-full max-w-md bg-card border border-border p-8 rounded-2xl shadow-xl text-center space-y-6">
          <div className="w-16 h-16 bg-red-500/10 border border-red-500/20 text-red-500 rounded-full flex items-center justify-center mx-auto text-2xl font-bold">
            ×
          </div>
          <div className="space-y-2">
            <h1 className="text-2xl font-black text-foreground">Authentication Failed</h1>
            <p className="text-muted-foreground text-sm leading-relaxed">{error}</p>
          </div>
          <Link
            href="/login"
            className="inline-block px-6 py-3 rounded-xl bg-[var(--accent-primary)] hover:opacity-90 font-bold text-background transition-all text-white dark:text-black"
          >
            Back to Login
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-[calc(100vh-64px)] flex items-center justify-center p-6 bg-background">
      <div className="text-center space-y-4">
        {/* Loading Spinner */}
        <div className="relative w-16 h-16 mx-auto">
          <div className="absolute inset-0 rounded-full border-4 border-border/40" />
          <div className="absolute inset-0 rounded-full border-4 border-t-[var(--accent-primary)] animate-spin" />
        </div>
        <div className="space-y-1">
          <h2 className="text-xl font-bold text-foreground">Verifying credentials</h2>
          <p className="text-muted-foreground text-sm">Completing authentication via GitHub...</p>
        </div>
      </div>
    </div>
  );
}

export default function GitHubCallbackPage() {
  return (
    <Suspense
      fallback={
        <div className="min-h-[calc(100vh-64px)] flex items-center justify-center">
          <div className="text-muted-foreground animate-pulse text-sm">Loading...</div>
        </div>
      }
    >
      <CallbackContent />
    </Suspense>
  );
}
