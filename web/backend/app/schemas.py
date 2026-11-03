# web/backend/app/schemas.py

from datetime import datetime
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

class CLIDeviceCodeResponse(BaseModel):
    device_code: str
    user_code: str
    verification_uri: str
    expires_in: int
    interval: int

class CLIAuthorizeRequest(BaseModel):
    user_code: str

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
    order: int
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
    module_id: str
    section_id: str
    data: LabSchema


# --- Sections ---

class SectionSchema(BaseModel):
    id: str
    title: str
    order: int
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

class MeResponse(BaseModel):
    id: int
    username: str
    email: str
    xp: int
    unverified_xp: int = 0
    is_maintainer: bool = False
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

class BuilderSectionInput(BaseModel):
    id: str
    title: str
    order: int
    xp: int = 10
    content: str | None = None          # None allowed in drafts, verified in publish gate
    labs: list[BuilderLabInput] = []

class BuilderModuleInput(BaseModel):
    id: str
    title: str
    description: str | None = None
    topic: str
    difficulty: str
    estimated_minutes: int | None = None
    sections: list[BuilderSectionInput] = []

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


