export interface User {
  id: number;
  username: string;
  email: string;
  xp: number;
  unverified_xp: number;
  is_maintainer: boolean;
  is_admin?: boolean;
  can_manage_workspaces?: boolean;
  platform_permissions?: string[];
  completed_labs: string[];
  completed_sections: string[];
}

export interface SessionResponse {
  id: number;
  client_type: string;
  user_agent: string | null;
  ip_address: string | null;
  created_at: string;
  expires_at: string;
  last_used_at: string | null;
  is_current: boolean;
}
