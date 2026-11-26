export function isDevEnvironment(): boolean {
  return (
    process.env.NEXT_PUBLIC_ENVIRONMENT === "development" ||
    process.env.NODE_ENV === "development"
  );
}

export function redirectToGithubOAuth(): { ok: boolean; error?: string } {
  const clientId = process.env.NEXT_PUBLIC_GITHUB_CLIENT_ID;
  if (isDevEnvironment() || !clientId) {
    return { ok: false, error: "Google and GitHub sign in is disabled in local development." };
  }
  const redirectUri = `${window.location.origin}/login/callback`;
  window.location.href = `https://github.com/login/oauth/authorize?client_id=${clientId}&redirect_uri=${encodeURIComponent(
    redirectUri
  )}&scope=user:email`;
  return { ok: true };
}

export function redirectToGoogleOAuth(): { ok: boolean; error?: string } {
  const clientId = process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID;
  if (isDevEnvironment() || !clientId) {
    return { ok: false, error: "Google and GitHub sign in is disabled in local development." };
  }
  const redirectUri = `${window.location.origin}/login/google/callback`;
  const params = new URLSearchParams({
    client_id: clientId,
    redirect_uri: redirectUri,
    response_type: "code",
    scope: "openid email profile",
    access_type: "offline",
  });
  window.location.href = `https://accounts.google.com/o/oauth2/v2/auth?${params}`;
  return { ok: true };
}
