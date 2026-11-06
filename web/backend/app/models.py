# web/backend/app/models.py

from datetime import datetime
from typing import Any
from sqlalchemy import BigInteger, Boolean, DateTime, ForeignKey, ForeignKeyConstraint, Index, Integer, JSON, String, Text, UniqueConstraint, func, text
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base


class User(Base):
    __tablename__ = "users"
    __table_args__ = (
        Index("uq_users_username_lower", text("lower(username)"), unique=True),
        Index("uq_users_email_lower", text("lower(email)"), unique=True),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    username: Mapped[str] = mapped_column(String(50), unique=True, nullable=False)
    email: Mapped[str] = mapped_column(String(255), unique=True, nullable=False)
    password_hash: Mapped[str] = mapped_column(String(255), nullable=False)
    is_verified: Mapped[bool] = mapped_column(Boolean, default=False, server_default="false")
    verification_token: Mapped[str | None] = mapped_column(String(64), unique=True, nullable=True)
    reset_token: Mapped[str | None] = mapped_column(String(64), unique=True, nullable=True)
    reset_token_expires_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    verification_token_expires_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    last_login_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    sessions: Mapped[list["UserSession"]] = relationship("UserSession", back_populates="user", cascade="all, delete-orphan")
    memberships: Mapped[list["OrganizationMembership"]] = relationship("OrganizationMembership", back_populates="user", cascade="all, delete-orphan")
    platform_roles: Mapped[list["PlatformUserRole"]] = relationship("PlatformUserRole", back_populates="user", cascade="all, delete-orphan", foreign_keys="PlatformUserRole.user_id")


class UserSession(Base):
    __tablename__ = "user_sessions"
    __table_args__ = (
        Index("idx_user_sessions_lookup", "session_token_hash", postgresql_where=text("revoked_at IS NULL")),
        Index("idx_user_sessions_user_id", "user_id"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    session_token_hash: Mapped[str] = mapped_column(String(64), unique=True, nullable=False)
    device_key: Mapped[str | None] = mapped_column(String(64), nullable=True)
    client_type: Mapped[str] = mapped_column(String(20), nullable=False)  # 'web', 'cli', 'desktop'
    user_agent: Mapped[str | None] = mapped_column(Text, nullable=True)
    ip_address: Mapped[str | None] = mapped_column(String(45), nullable=True)
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    revoked_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    last_used_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    user: Mapped["User"] = relationship("User", back_populates="sessions")


class CLIDeviceAuth(Base):
    __tablename__ = "cli_device_auths"
    __table_args__ = (
        Index("idx_cli_device_auths_polling", "device_code_hash", "status"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    device_code: Mapped[str] = mapped_column(String(64), index=True, unique=True, nullable=False)
    device_code_hash: Mapped[str] = mapped_column(String(64), unique=True, nullable=False)
    user_code: Mapped[str] = mapped_column(String(20), index=True, unique=True, nullable=False)
    user_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("users.id"), nullable=True)
    status: Mapped[str] = mapped_column(String(20), default="pending", nullable=False)
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    user: Mapped["User | None"] = relationship("User")


class Module(Base):
    __tablename__ = "modules"
    __table_args__ = (
        Index("idx_modules_owner", "owner_organization_id"),
        Index("idx_modules_sections", "sections", postgresql_using="gin"),
    )

    id: Mapped[str] = mapped_column(String(100), primary_key=True)
    owner_organization_id: Mapped[int] = mapped_column(Integer, ForeignKey("organizations.id", ondelete="CASCADE"), nullable=False)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    topic: Mapped[str | None] = mapped_column(String(50), nullable=True)
    difficulty: Mapped[str | None] = mapped_column(String(20), nullable=True)
    estimated_minutes: Mapped[int | None] = mapped_column(Integer, nullable=True)
    version: Mapped[int] = mapped_column(Integer, default=1, nullable=False)
    total_xp: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    sections: Mapped[list[str]] = mapped_column(JSONB, default=list, server_default=text("'[]'::jsonb"), nullable=False)
    shared_seed: Mapped[list[str] | None] = mapped_column(JSON, nullable=True)
    author_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("users.id"), nullable=True)
    updated_by: Mapped[int | None] = mapped_column(Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    status: Mapped[str] = mapped_column(String(20), default="draft", server_default="draft", nullable=False)
    submitted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    owner_organization: Mapped["Organization"] = relationship("Organization")
    author: Mapped["User | None"] = relationship("User", foreign_keys=[author_id])

    @property
    def total_sections(self) -> int:
        return len(self.sections or [])


class Section(Base):
    __tablename__ = "sections"
    __table_args__ = (
        Index("idx_sections_owner", "owner_organization_id"),
        Index("idx_sections_labs", "labs", postgresql_using="gin"),
    )

    id: Mapped[str] = mapped_column(String(100), primary_key=True)
    owner_organization_id: Mapped[int] = mapped_column(Integer, ForeignKey("organizations.id", ondelete="CASCADE"), nullable=False)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    xp: Mapped[int] = mapped_column(Integer, default=10)
    content: Mapped[str | None] = mapped_column(Text, nullable=True)
    labs: Mapped[list[str]] = mapped_column(JSONB, default=list, server_default=text("'[]'::jsonb"), nullable=False)
    version: Mapped[int] = mapped_column(Integer, default=1, nullable=False)
    created_by: Mapped[int | None] = mapped_column(Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    owner_organization: Mapped["Organization"] = relationship("Organization")
    progress: Mapped[list["SectionProgress"]] = relationship("SectionProgress", back_populates="section")


class Lab(Base):
    __tablename__ = "labs"
    __table_args__ = (
        Index("idx_labs_owner", "owner_organization_id"),
    )

    id: Mapped[str] = mapped_column(String(100), primary_key=True)  # globally unique
    owner_organization_id: Mapped[int] = mapped_column(Integer, ForeignKey("organizations.id", ondelete="CASCADE"), nullable=False)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    xp: Mapped[int] = mapped_column(Integer, default=0)
    estimated_minutes: Mapped[int | None] = mapped_column(Integer, nullable=True)
    environment_profile: Mapped[str] = mapped_column(String(50), default="tld-ubuntu", server_default="tld-ubuntu", nullable=False)
    seed_commands: Mapped[str | None] = mapped_column(Text, nullable=True)
    version: Mapped[int] = mapped_column(Integer, default=1, nullable=False)
    validator_hash: Mapped[str | None] = mapped_column(String(64), nullable=True)
    validator_script: Mapped[str | None] = mapped_column(Text, nullable=True)
    created_by: Mapped[int | None] = mapped_column(Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    owner_organization: Mapped["Organization"] = relationship("Organization")
    progress: Mapped[list["LabProgress"]] = relationship("LabProgress", back_populates="lab")


class LabProgress(Base):
    """Tracks completion of individual labs per organization membership."""
    __tablename__ = "lab_progress"
    __table_args__ = (
        UniqueConstraint("organization_membership_id", "lab_id", name="uq_lab_progress_membership_lab"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    organization_membership_id: Mapped[int] = mapped_column(Integer, ForeignKey("organization_memberships.id", ondelete="CASCADE"), index=True, nullable=False)
    lab_id: Mapped[str] = mapped_column(String(100), ForeignKey("labs.id", ondelete="CASCADE"), index=True, nullable=False)
    xp_awarded: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    membership: Mapped["OrganizationMembership"] = relationship("OrganizationMembership", back_populates="lab_progress")
    lab: Mapped["Lab"] = relationship("Lab", back_populates="progress")


class SectionProgress(Base):
    """Tracks completion of sections per organization membership."""
    __tablename__ = "section_progress"
    __table_args__ = (
        UniqueConstraint("organization_membership_id", "section_id", name="uq_section_progress_membership_section"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    organization_membership_id: Mapped[int] = mapped_column(Integer, ForeignKey("organization_memberships.id", ondelete="CASCADE"), index=True, nullable=False)
    section_id: Mapped[str] = mapped_column(String(100), ForeignKey("sections.id", ondelete="CASCADE"), index=True, nullable=False)
    xp_awarded: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    membership: Mapped["OrganizationMembership"] = relationship("OrganizationMembership", back_populates="section_progress")
    section: Mapped["Section"] = relationship("Section", back_populates="progress")


# =============================================================================
# MODULE B – Organizations, Workspaces & RBAC
# =============================================================================

class Organization(Base):
    __tablename__ = "organizations"
    __table_args__ = (
        Index(
            "uq_single_platform_org",
            "is_platform",
            unique=True,
            postgresql_where=text("is_platform = true"),
        ),
        Index("idx_organizations_domains", "domains", postgresql_using="gin"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    slug: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)
    type: Mapped[str] = mapped_column(String(50), nullable=False)  # 'platform', 'university', 'company', 'other'
    is_platform: Mapped[bool] = mapped_column(Boolean, default=False, server_default="false", nullable=False)
    status: Mapped[str] = mapped_column(String(50), default="active", server_default="active", nullable=False)
    domains: Mapped[list[str]] = mapped_column(JSONB, default=list, server_default=text("'[]'::jsonb"), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    memberships: Mapped[list["OrganizationMembership"]] = relationship("OrganizationMembership", back_populates="organization", cascade="all, delete-orphan")
    cohorts: Mapped[list["Cohort"]] = relationship("Cohort", back_populates="organization", cascade="all, delete-orphan")
    learning_paths: Mapped[list["LearningPath"]] = relationship("LearningPath", back_populates="organization", cascade="all, delete-orphan")


class OrganizationMembership(Base):
    __tablename__ = "organization_memberships"
    __table_args__ = (
        UniqueConstraint("id", "organization_id", name="uq_organization_memberships_id_org"),
        Index("idx_org_memberships_user", "user_id"),
        Index(
            "uq_org_active_membership",
            "organization_id",
            "user_id",
            unique=True,
            postgresql_where=text("status != 'removed'"),
        ),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    organization_id: Mapped[int] = mapped_column(Integer, ForeignKey("organizations.id", ondelete="CASCADE"), nullable=False)
    user_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    status: Mapped[str] = mapped_column(String(50), default="active", server_default="active", nullable=False)
    total_xp: Mapped[int] = mapped_column(BigInteger, default=0, server_default="0", nullable=False)
    unverified_xp: Mapped[int] = mapped_column(BigInteger, default=0, server_default="0", nullable=False)
    joined_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    removed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    organization: Mapped["Organization"] = relationship("Organization", back_populates="memberships")
    user: Mapped["User"] = relationship("User", back_populates="memberships")
    roles: Mapped[list["MembershipRole"]] = relationship("MembershipRole", back_populates="membership", cascade="all, delete-orphan")
    cohort_memberships: Mapped[list["CohortMembership"]] = relationship("CohortMembership", back_populates="membership", cascade="all, delete-orphan", overlaps="cohort,memberships")
    lab_progress: Mapped[list["LabProgress"]] = relationship("LabProgress", back_populates="membership", cascade="all, delete-orphan")
    section_progress: Mapped[list["SectionProgress"]] = relationship("SectionProgress", back_populates="membership", cascade="all, delete-orphan")


class Permission(Base):
    __tablename__ = "permissions"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    key: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class Role(Base):
    __tablename__ = "roles"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    slug: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    is_system: Mapped[bool] = mapped_column(Boolean, default=True, server_default="true", nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    permissions: Mapped[list["RolePermission"]] = relationship("RolePermission", back_populates="role", cascade="all, delete-orphan")


class RolePermission(Base):
    __tablename__ = "role_permissions"
    __table_args__ = (
        UniqueConstraint("role_id", "permission_id", name="uq_role_permissions_role_perm"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    role_id: Mapped[int] = mapped_column(Integer, ForeignKey("roles.id", ondelete="CASCADE"), nullable=False)
    permission_id: Mapped[int] = mapped_column(Integer, ForeignKey("permissions.id", ondelete="CASCADE"), nullable=False)

    role: Mapped["Role"] = relationship("Role", back_populates="permissions")
    permission: Mapped["Permission"] = relationship("Permission")


class OrganizationRoleAvailability(Base):
    __tablename__ = "organization_role_availability"
    __table_args__ = (
        UniqueConstraint("organization_id", "role_id", name="uq_org_role_avail"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    organization_id: Mapped[int] = mapped_column(Integer, ForeignKey("organizations.id", ondelete="CASCADE"), nullable=False)
    role_id: Mapped[int] = mapped_column(Integer, ForeignKey("roles.id", ondelete="RESTRICT"), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    organization: Mapped["Organization"] = relationship("Organization")
    role: Mapped["Role"] = relationship("Role")


class MembershipRole(Base):
    __tablename__ = "membership_roles"
    __table_args__ = (
        UniqueConstraint("membership_id", "role_id", name="uq_membership_roles"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    membership_id: Mapped[int] = mapped_column(Integer, ForeignKey("organization_memberships.id", ondelete="CASCADE"), nullable=False)
    role_id: Mapped[int] = mapped_column(Integer, ForeignKey("roles.id", ondelete="RESTRICT"), nullable=False)
    assigned_by: Mapped[int | None] = mapped_column(Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    assigned_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    membership: Mapped["OrganizationMembership"] = relationship("OrganizationMembership", back_populates="roles")
    role: Mapped["Role"] = relationship("Role")
    assigner: Mapped["User | None"] = relationship("User", foreign_keys=[assigned_by])


class PlatformRole(Base):
    __tablename__ = "platform_roles"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    slug: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    permissions: Mapped[list["PlatformRolePermission"]] = relationship("PlatformRolePermission", back_populates="platform_role", cascade="all, delete-orphan")


class PlatformPermission(Base):
    __tablename__ = "platform_permissions"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    key: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class PlatformRolePermission(Base):
    __tablename__ = "platform_role_permissions"
    __table_args__ = (
        UniqueConstraint("platform_role_id", "permission_id", name="uq_platform_role_perms"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    platform_role_id: Mapped[int] = mapped_column(Integer, ForeignKey("platform_roles.id", ondelete="CASCADE"), nullable=False)
    permission_id: Mapped[int] = mapped_column(Integer, ForeignKey("platform_permissions.id", ondelete="CASCADE"), nullable=False)

    platform_role: Mapped["PlatformRole"] = relationship("PlatformRole", back_populates="permissions")
    permission: Mapped["PlatformPermission"] = relationship("PlatformPermission")


class PlatformUserRole(Base):
    __tablename__ = "platform_user_roles"
    __table_args__ = (
        UniqueConstraint("user_id", "platform_role_id", name="uq_platform_user_roles"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    platform_role_id: Mapped[int] = mapped_column(Integer, ForeignKey("platform_roles.id", ondelete="RESTRICT"), nullable=False)
    assigned_by: Mapped[int | None] = mapped_column(Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    assigned_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    user: Mapped["User"] = relationship("User", back_populates="platform_roles", foreign_keys=[user_id])
    platform_role: Mapped["PlatformRole"] = relationship("PlatformRole")
    assigner: Mapped["User | None"] = relationship("User", foreign_keys=[assigned_by])


class Cohort(Base):
    __tablename__ = "cohorts"
    __table_args__ = (
        UniqueConstraint("id", "organization_id", name="uq_cohorts_id_org"),
        Index("idx_cohorts_learning_paths", "learning_paths", postgresql_using="gin"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    organization_id: Mapped[int] = mapped_column(Integer, ForeignKey("organizations.id", ondelete="CASCADE"), nullable=False)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    status: Mapped[str] = mapped_column(String(50), default="active", server_default="active", nullable=False)
    learning_paths: Mapped[list] = mapped_column(JSONB, default=list, server_default="[]", nullable=False)
    starts_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    ends_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    created_by: Mapped[int | None] = mapped_column(Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    organization: Mapped["Organization"] = relationship("Organization", back_populates="cohorts")
    memberships: Mapped[list["CohortMembership"]] = relationship("CohortMembership", back_populates="cohort", cascade="all, delete-orphan", overlaps="cohort,memberships")
    invites: Mapped[list["CohortInvite"]] = relationship("CohortInvite", back_populates="cohort", cascade="all, delete-orphan")


class CohortMembership(Base):
    __tablename__ = "cohort_memberships"
    __table_args__ = (
        ForeignKeyConstraint(
            ["cohort_id", "organization_id"],
            ["cohorts.id", "cohorts.organization_id"],
            ondelete="CASCADE",
        ),
        ForeignKeyConstraint(
            ["organization_membership_id", "organization_id"],
            ["organization_memberships.id", "organization_memberships.organization_id"],
            ondelete="CASCADE",
        ),
        UniqueConstraint("cohort_id", "organization_membership_id", name="uq_cohort_memberships"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    organization_id: Mapped[int] = mapped_column(Integer, nullable=False)
    cohort_id: Mapped[int] = mapped_column(Integer, nullable=False)
    organization_membership_id: Mapped[int] = mapped_column(Integer, nullable=False)
    joined_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    removed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    cohort: Mapped["Cohort"] = relationship("Cohort", back_populates="memberships", overlaps="cohort,memberships")
    membership: Mapped["OrganizationMembership"] = relationship("OrganizationMembership", back_populates="cohort_memberships", overlaps="cohort,memberships")


class CohortInvite(Base):
    __tablename__ = "cohort_invites"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    cohort_id: Mapped[int] = mapped_column(Integer, ForeignKey("cohorts.id", ondelete="CASCADE"), nullable=False)
    code_hash: Mapped[str] = mapped_column(String(64), unique=True, nullable=False)
    expires_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    max_uses: Mapped[int | None] = mapped_column(Integer, nullable=True)
    used_count: Mapped[int] = mapped_column(Integer, default=0, server_default="0", nullable=False)
    created_by: Mapped[int | None] = mapped_column(Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    revoked_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    cohort: Mapped["Cohort"] = relationship("Cohort", back_populates="invites")


class LearningPath(Base):
    __tablename__ = "learning_paths"
    __table_args__ = (
        UniqueConstraint("organization_id", "slug", name="uq_learning_paths_org_slug"),
        UniqueConstraint("id", "organization_id", name="uq_learning_paths_id_org"),
        Index("idx_learning_paths_modules", "modules", postgresql_using="gin"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    organization_id: Mapped[int] = mapped_column(Integer, ForeignKey("organizations.id", ondelete="CASCADE"), nullable=False)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    slug: Mapped[str] = mapped_column(String(100), nullable=False)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    visibility: Mapped[str] = mapped_column(String(20), default="public", server_default="public", nullable=False)
    status: Mapped[str] = mapped_column(String(50), default="active", server_default="active", nullable=False)
    modules: Mapped[list] = mapped_column(JSONB, default=list, server_default="[]", nullable=False)
    created_by: Mapped[int | None] = mapped_column(Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    organization: Mapped["Organization"] = relationship("Organization", back_populates="learning_paths")


class AuditLog(Base):
    __tablename__ = "audit_logs"
    __table_args__ = (
        Index("idx_audit_logs_org_created", "organization_id", text("created_at DESC")),
        Index("idx_audit_logs_actor", "actor_user_id", text("created_at DESC")),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    organization_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("organizations.id", ondelete="SET NULL"), nullable=True)
    actor_user_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    action: Mapped[str] = mapped_column(String(100), nullable=False)
    entity_type: Mapped[str] = mapped_column(String(100), nullable=False)
    entity_id: Mapped[str | None] = mapped_column(String(100), nullable=True)
    metadata_: Mapped[dict] = mapped_column("metadata", JSONB, default=dict, server_default=text("'{}'::jsonb"), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class OrganizationSettingAvailability(Base):
    __tablename__ = "organization_setting_availability"
    __table_args__ = (
        UniqueConstraint("organization_id", "setting_key", name="uq_org_setting_avail"),
        Index("idx_org_setting_avail_org", "organization_id"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    organization_id: Mapped[int] = mapped_column(Integer, ForeignKey("organizations.id", ondelete="CASCADE"), nullable=False)
    setting_key: Mapped[str] = mapped_column(String(100), nullable=False)
    is_enabled: Mapped[bool] = mapped_column(Boolean, default=True, server_default="true", nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    organization: Mapped["Organization"] = relationship("Organization")


class OrganizationSetting(Base):
    __tablename__ = "organization_settings"
    __table_args__ = (
        UniqueConstraint("organization_id", "setting_key", name="uq_org_settings"),
        Index("idx_org_settings_org", "organization_id"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    organization_id: Mapped[int] = mapped_column(Integer, ForeignKey("organizations.id", ondelete="CASCADE"), nullable=False)
    setting_key: Mapped[str] = mapped_column(String(100), nullable=False)
    value: Mapped[Any] = mapped_column(JSONB, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    organization: Mapped["Organization"] = relationship("Organization")
