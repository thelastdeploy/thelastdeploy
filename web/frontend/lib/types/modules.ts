export type Topic = "docker" | "kubernetes" | "linux" | "git" | "jenkins" | "terraform" | "nginx";
export type Difficulty = "foundational" | "beginner" | "intermediate" | "advanced" | "expert";

export interface Lab {
  id: string;
  title: string;
  order: number;
  xp: number;
  estimated_minutes: number | null;
  environment_profile?: string;
  seed_commands: string | null;
  completed: boolean;
  xp_awarded: number;
}

export interface Section {
  id: string;
  title: string;
  order: number;
  xp: number;
  content: string | null;
  labs: Lab[];
  section_completed: boolean;
}

export interface AuthorInfo {
  name: string;
  is_official: boolean;
}

export type ModuleStatus = "draft" | "published" | "pending" | "verified";

export interface Module {
  id: string;
  title: string;
  description: string | null;
  topic: Topic;
  difficulty: Difficulty;
  estimated_minutes: number | null;
  shared_seed?: string[];
  total_xp: number;
  total_sections: number;
  completed_sections: number;
  author: AuthorInfo;
  status?: ModuleStatus;
  is_official_verified?: boolean;
}

export interface ModuleDetail extends Module {
  sections: Section[];
}
