import { Building2, BarChart3, KeyRound, SlidersHorizontal } from "lucide-react";

export type DomainKey = "all" | "security" | "tenants" | "analytics";
export type RiskLevel = "critical" | "elevated" | "standard" | "readonly";

export interface PermMetadata {
  domain: DomainKey;
  risk: RiskLevel;
  humanName: string;
  categoryLabel: string;
}

export const PERMISSION_TAXONOMY: Record<string, PermMetadata> = {
  "platform.permissions.manage": {
    domain: "security",
    risk: "critical",
    humanName: "Root Delegation Authority",
    categoryLabel: "Security & Access",
  },
  "platform.users.manage": {
    domain: "security",
    risk: "elevated",
    humanName: "Add Platform Users",
    categoryLabel: "Security & Access",
  },
  "platform.users.view": {
    domain: "security",
    risk: "readonly",
    humanName: "View Platform Users",
    categoryLabel: "Security & Access",
  },
  "platform.organizations.suspend": {
    domain: "tenants",
    risk: "critical",
    humanName: "Suspend / Reactivate Tenant",
    categoryLabel: "Tenant Governance",
  },
  "platform.organizations.manage": {
    domain: "tenants",
    risk: "critical",
    humanName: "Manage Tenant Workspaces",
    categoryLabel: "Tenant Governance",
  },
  "platform.organizations.settings": {
    domain: "tenants",
    risk: "elevated",
    humanName: "Platform Setting Availability & Overrides",
    categoryLabel: "Tenant Governance",
  },
  "platform.organizations.create": {
    domain: "tenants",
    risk: "standard",
    humanName: "Provision New Organization",
    categoryLabel: "Tenant Governance",
  },
  "platform.organizations.view": {
    domain: "tenants",
    risk: "readonly",
    humanName: "Inspect Organizations Catalog",
    categoryLabel: "Tenant Governance",
  },
  "platform.analytics.export": {
    domain: "analytics",
    risk: "standard",
    humanName: "Export Platform Intelligence (CSV)",
    categoryLabel: "Analytics & Audit",
  },
  "platform.analytics.view": {
    domain: "analytics",
    risk: "readonly",
    humanName: "Access Global Analytics",
    categoryLabel: "Analytics & Audit",
  },
  "platform.audit.view": {
    domain: "analytics",
    risk: "readonly",
    humanName: "Inspect Platform Audit Logs",
    categoryLabel: "Analytics & Audit",
  },
};

export const DOMAIN_SECTIONS: {
  id: DomainKey;
  label: string;
  icon: any;
  description: string;
}[] = [
  {
    id: "all",
    label: "All Permissions",
    icon: SlidersHorizontal,
    description: "Overview of complete platform capability catalog.",
  },
  {
    id: "security",
    label: "Security & RBAC",
    icon: KeyRound,
    description: "Administrative delegation, operator provisioning, and user access control.",
  },
  {
    id: "tenants",
    label: "Tenant Governance",
    icon: Building2,
    description: "Organization lifecycle, suspension, setting enablement, and override values.",
  },
  {
    id: "analytics",
    label: "Analytics & Audit",
    icon: BarChart3,
    description: "Platform-wide KPI dashboards, audit trails, and data export pipelines.",
  },
];
