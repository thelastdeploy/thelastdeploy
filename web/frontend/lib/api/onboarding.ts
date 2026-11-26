import type { InvitationVerifyResponse, OrganizationPublicInfoResponse } from "../types";
import { request } from "./client";

export const onboardingApi = {
  getOrganizationInfo: () =>
    request<OrganizationPublicInfoResponse>("/onboarding/organization-info"),

  requestAccess: (email: string) =>
    request<{ detail: string; status: string; mode?: string }>("/onboarding/access-request", {
      method: "POST",
      body: JSON.stringify({ email }),
    }),

  verifyInvitation: (token?: string, code?: string) =>
    request<InvitationVerifyResponse>("/onboarding/invitations/verify", {
      method: "POST",
      body: JSON.stringify({ token, code }),
    }),

  redeemInvitation: (token?: string, code?: string) =>
    request<{
      detail: string;
      access_token?: string;
      onboarding_token?: string;
      requires_password_setup?: boolean;
    }>("/onboarding/invitations/redeem", {
      method: "POST",
      body: JSON.stringify({ token, code }),
    }),

  completeOnboardingSetup: (onboardingToken: string, username: string, password: string) =>
    request<{ detail: string; access_token: string }>("/onboarding/invitations/complete-setup", {
      method: "POST",
      body: JSON.stringify({
        onboarding_token: onboardingToken,
        username,
        password,
      }),
    }),
};
