// Barrel API client combining domain modules for backwards compatibility.
export { getApiBaseUrl } from "./api/client";
import { authApi } from "./api/auth";
import { onboardingApi } from "./api/onboarding";
import { modulesApi } from "./api/modules";
import { orgApi } from "./api/org";
import { platformApi } from "./api/platform";

export const api = {
  ...authApi,
  ...onboardingApi,
  ...modulesApi,
  ...orgApi,
  ...platformApi,
};
