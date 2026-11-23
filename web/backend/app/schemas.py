# web/backend/app/schemas.py

from datetime import datetime
from typing import Any
from pydantic import BaseModel, EmailStr


# --- Auth ---

class RegisterRequest(BaseModel):
    email: EmailStr
    username: str
    password: str

class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    device_key: str

class VerifyEmailRequest(BaseModel):
    token: str

class ForgotPasswordRequest(BaseModel):
    email: EmailStr

class ResetPasswordRequest(BaseModel):
    token: str
    password: str

class ResendVerificationRequest(BaseModel):
    email: EmailStr

class MessageResponse(BaseModel):
    detail: str


class SessionResponse(BaseModel):
    id: int
    client_type: str
    user_agent: str | None = None
    ip_address: str | None = None
    created_at: datetime
    expires_at: datetime
    last_used_at: datetime | None = None
    is_current: bool = False

class CLIDeviceCodeResponse(BaseModel):
    device_code: str
    user_code: str
    verification_uri: str
    expires_in: int
    interval: int

class CLIAuthorizeRequest(BaseModel):
    user_code: str
    action: str = "approve"  # "approve" | "deny"

class CLITokenRequest(BaseModel):
    device_code: str

class GitHubLoginRequest(BaseModel):
    code: str

class GoogleLoginRequest(BaseModel):
    code: str
    redirect_uri: str   # Must match what was sent in the authorization URL


# --- User Updates ---

class ProfileUpdateRequest(BaseModel):
    username: str | None = None
    email: EmailStr | None = None

class PasswordUpdateRequest(BaseModel):
    old_password: str
    new_password: str


# --- Labs ---

class LabSchema(BaseModel):
    id: str
    title: str
    order: int = 0
    xp: int
    estimated_minutes: int | None = None
    environment_profile: str = "tld-ubuntu"
    seed_commands: str | None = None
    completed: bool = False
    xp_awarded: int = 0
    version: int = 1

    class Config:
        from_attributes = True


class LabDetail(BaseModel):
    """Response for GET /labs/:id — includes location metadata for agent sync."""
    id: str
    module_id: str = ""
    section_id: str = ""
    data: LabSchema


# --- Sections ---

class SectionSchema(BaseModel):
    id: str
    title: str
    order: int = 0
    xp: int = 10                    # reading XP from section.yaml
    content: str | None = None
    labs: list[LabSchema] = []
    section_completed: bool = False  # reading scroll / future: questions
    version: int = 1

    class Config:
        from_attributes = True


# --- Author ---

class AuthorInfo(BaseModel):
    name: str
    is_official: bool


# --- Modules ---

class ModuleListItem(BaseModel):
    id: str
    title: str
    description: str | None
    topic: str | None
    difficulty: str | None
    estimated_minutes: int | None
    total_xp: int = 0
    total_sections: int = 0
    completed_sections: int = 0
    version: int = 1
    author: AuthorInfo
    status: str = "verified"
    is_official_verified: bool = False

class ModuleListResponse(BaseModel):
    modules: list[ModuleListItem]

class ModuleDetail(BaseModel):
    id: str
    title: str
    description: str | None
    topic: str | None
    difficulty: str | None
    estimated_minutes: int | None
    shared_seed: list[str] = []
    total_xp: int
    total_sections: int
    sections: list[SectionSchema]
    version: int = 1
    author: AuthorInfo
    status: str = "verified"
    is_official_verified: bool = False

class ModuleSummary(BaseModel):
    """Lightweight for GET /modules/:id (tld sync -m)."""
    id: str
    title: str
    description: str | None
    topic: str | None
    difficulty: str | None
    estimated_minutes: int | None
    shared_seed: list[str] = []
    total_xp: int
    total_sections: int
    version: int = 1
    author: AuthorInfo
    status: str = "verified"
    is_official_verified: bool = False

class VerifyLabXP(BaseModel):
    id: str
    xp: int

class VerifySectionXP(BaseModel):
    id: str
    xp: int
    labs: list[VerifyLabXP] = []

class VerifyModulePayload(BaseModel):
    sections: list[VerifySectionXP] = []

class RejectModulePayload(BaseModel):
    reason: str | None = None


# --- Progress ---

class CompleteSectionResponse(BaseModel):
    xp_awarded: int
    total_xp: int


# --- Results (from tld check) ---

class ResultRequest(BaseModel):
    lab_id: str
    section_id: str
    passed: bool
    output: str | None = None
    ran_at: datetime | None = None
    signature: str | None = None
    queued_at: datetime | None = None
    validator_hash: str | None = None

class ResultResponse(BaseModel):
    xp_awarded: int


# --- Users ---

class MaintainerAddRequest(BaseModel):
    identity: str

class MeResponse(BaseModel):
    id: int
    username: str
    email: str
    xp: int
    unverified_xp: int = 0
    is_maintainer: bool = False
    is_admin: bool = False
    can_manage_workspaces: bool = False
    platform_roles: list[str] = []
    platform_permissions: list[str] = []
    completed_labs: list[str]       # lab IDs (from lab_progress)
    completed_sections: list[str]   # section IDs (from section_progress — reading/questions)


# --- Builder (Module Authoring) ---

class BuilderLabInput(BaseModel):
    id: str
    title: str
    order: int
    xp: int = 30
    estimated_minutes: int | None = None
    environment_profile: str = "tld-ubuntu"
    seed_commands: list[str] = []
    validator_script: str | None = None  # None allowed in drafts, verified in publish gate
    cleanup_script: str | None = None
    content_hash: str | None = None
    is_org_owned: bool = True
    original_id: str | None = None

class BuilderSectionInput(BaseModel):
    id: str
    title: str
    order: int
    xp: int = 10
    content: str | None = None          # None allowed in drafts, verified in publish gate
    content_hash: str | None = None
    is_org_owned: bool = True
    original_id: str | None = None
    labs: list[BuilderLabInput] = []

class BuilderModuleInput(BaseModel):
    id: str
    title: str
    description: str | None = None
    topic: str
    difficulty: str
    estimated_minutes: int | None = None
    content_hash: str | None = None
    is_org_owned: bool = True
    original_id: str | None = None
    sections: list[BuilderSectionInput] = []

class LabExportItem(BaseModel):
    id: str
    title: str
    order: int
    estimated_minutes: int | None = None
    environment_profile: str = "tld-ubuntu"
    seed_commands: list[str] = []
    validator_script: str | None = None
    cleanup_script: str | None = None
    raw_lab_yaml: str | None = None
    is_python_validator: bool = False
    content_hash: str | None = None

class SectionExportItem(BaseModel):
    id: str
    title: str
    order: int
    content: str | None = None
    raw_section_yaml: str | None = None
    content_hash: str | None = None
    labs: list[LabExportItem] = []

class ModuleExportResponse(BaseModel):
    id: str
    title: str
    description: str | None = None
    topic: str | None = None
    difficulty: str | None = None
    estimated_minutes: int | None = None
    raw_module_yaml: str | None = None
    content_hash: str | None = None
    owner_organization_id: int
    is_official_verified: bool
    sections: list[SectionExportItem] = []

class BuilderDraftListItem(BaseModel):
    id: str
    title: str
    topic: str | None
    difficulty: str | None
    total_sections: int
    total_xp: int
    status: str                     # 'draft' | 'published' | 'verified'
    is_official_verified: bool = False
    created_at: datetime
    submitted_at: datetime | None

class BuilderModuleDetail(BaseModel):
    id: str
    title: str
    description: str | None
    topic: str | None
    difficulty: str | None
    estimated_minutes: int | None
    status: str
    sections: list[BuilderSectionInput]


class BuilderModuleResponse(BaseModel):
    id: str
    title: str
    status: str = "published"
    is_official_verified: bool = False
    total_sections: int
    total_xp: int
    created_at: datetime


# --- Module B: Organizations & Workspaces ---

class OrganizationResponse(BaseModel):
    id: int
    name: str
    slug: str
    type: str
    is_platform: bool
    status: str
    domains: list[str] = []
    roles: list[str] = []
    total_xp: int = 0
    unverified_xp: int = 0
    joined_at: datetime | None = None


class OrganizationCreateRequest(BaseModel):
    name: str
    slug: str
    type: str = "university"  # 'university', 'company', 'other'
    domains: list[str] = []


class OrganizationMemberResponse(BaseModel):
    membership_id: int
    user_id: int
    username: str
    email: str
    status: str
    roles: list[str] = []
    total_xp: int = 0
    unverified_xp: int = 0
    joined_at: datetime


class MemberRoleUpdateRequest(BaseModel):
    role: str  # 'admin', 'instructor', 'learner'


class CohortMemberResponse(BaseModel):
    membership_id: int
    cohort_membership_id: int
    user_id: int
    username: str
    email: str
    total_xp: int = 0
    joined_at: datetime


class AuditLogResponse(BaseModel):
    id: int
    organization_id: int | None = None
    actor_user_id: int | None = None
    actor_username: str | None = None
    action: str
    entity_type: str
    entity_id: str | None = None
    metadata: dict = {}
    created_at: datetime


class CohortCreateRequest(BaseModel):
    name: str
    description: str | None = None
    learning_paths: list[int] = []
    starts_at: datetime
    ends_at: datetime


class CohortUpdateRequest(BaseModel):
    name: str | None = None
    description: str | None = None
    status: str | None = None
    learning_paths: list[int] | None = None
    starts_at: datetime | None = None
    ends_at: datetime | None = None


class CohortMemberAddRequest(BaseModel):
    user_id: int


class CohortResponse(BaseModel):
    id: int
    organization_id: int
    name: str
    description: str | None = None
    status: str
    learning_paths: list[int] = []
    starts_at: datetime
    ends_at: datetime
    created_at: datetime


class LearningPathCreateRequest(BaseModel):
    name: str
    slug: str
    description: str | None = None
    visibility: str | None = None  # 'public' or 'private', falls back to Module E setting
    modules: list[str] = []


class LearningPathUpdateRequest(BaseModel):
    name: str | None = None
    description: str | None = None
    visibility: str | None = None  # 'public' or 'private'
    status: str | None = None
    modules: list[str] | None = None


class LearningPathResponse(BaseModel):
    id: int
    organization_id: int
    name: str
    slug: str
    description: str | None = None
    visibility: str
    status: str
    modules: list[str] = []
    module_count: int = 0
    created_at: datetime


# --- Module E: Organization Settings & Configuration ---

class OrgSettingItemResponse(BaseModel):
    key: str
    value: Any
    category: str
    description: str
    data_type: str
    updated_at: datetime | None = None


class OrgSettingAdminItemResponse(BaseModel):
    key: str
    is_enabled: bool
    value: Any | None = None
    default: Any
    category: str
    description: str
    data_type: str
    updated_at: datetime | None = None


class OrgSettingUpdateRequest(BaseModel):
    value: Any


class OrgSettingEnableRequest(BaseModel):
    initial_value: Any | None = None


# --- Module F: Invitations & Organization Onboarding ---

class OrganizationPublicInfoResponse(BaseModel):
    id: int
    name: str
    slug: str
    type: str
    domains: list[str] = []
    approval_mode: str = "automatic"

class AccessRequestCreate(BaseModel):
    email: EmailStr

class AccessRequestResponse(BaseModel):
    id: int
    organization_id: int
    email: str
    status: str
    requested_at: datetime
    reviewed_at: datetime | None = None
    rejection_reason: str | None = None
    issued_invitation_id: int | None = None

class AccessRequestRejectPayload(BaseModel):
    reason: str | None = None

class InvitationCreateRequest(BaseModel):
    email: EmailStr
    cohort_id: int | None = None

class BulkInvitationResultItem(BaseModel):
    email: str
    status: str  # created, skipped_duplicate, invalid_format, error
    detail: str | None = None

class BulkInvitationResponse(BaseModel):
    total_processed: int
    created_count: int
    skipped_count: int
    results: list[BulkInvitationResultItem]

class InvitationResponse(BaseModel):
    id: int
    organization_id: int
    cohort_id: int | None = None
    email: str
    invitation_code: str | None = None
    status: str
    created_at: datetime
    expires_at: datetime
    redeemed_at: datetime | None = None
    revoked_at: datetime | None = None
    created_by_user_id: int | None = None

class InvitationDetailResponse(InvitationResponse):
    organization_name: str
    organization_slug: str
    cohort_name: str | None = None

class InvitationVerifyRequest(BaseModel):
    token: str | None = None
    code: str | None = None

class InvitationVerifyResponse(BaseModel):
    valid: bool
    email: str
    organization_name: str
    organization_slug: str
    cohort_name: str | None = None
    is_existing_user: bool
    requires_password_setup: bool

class InvitationRedeemRequest(BaseModel):
    token: str | None = None
    code: str | None = None

class OnboardingCompleteSetupRequest(BaseModel):
    onboarding_token: str
    username: str
    password: str

class InvitationStatsResponse(BaseModel):
    total_invitations: int
    pending_invitations: int
    accepted_invitations: int
    expired_invitations: int
    revoked_invitations: int
    pending_access_requests: int




