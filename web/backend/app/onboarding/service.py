# web/backend/app/onboarding/service.py

import csv
import hashlib
import io
import re
import secrets
from datetime import datetime, timedelta, timezone
from typing import Any
from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, and_, func

from app.models import (
    User,
    Organization,
    OrganizationMembership,
    Role,
    Cohort,
    CohortMembership,
    OrganizationInvitation,
    OrganizationAccessRequest,
    LearningPath,
    AuditLog,
)
from jose import jwt
from app.config import settings
from app.auth import (
    hash_password,
    create_access_token,
    decode_token_payload,
    hash_token,
)
from app.services import log_audit_event
from app.settings.service import SettingsService

EMAIL_REGEX = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")


def is_domain_eligible(email: str, allowed_domains: list[str]) -> bool:
    """
    Checks if an email address belongs to any authorized domain.
    Supports exact match (e.g. apex.edu) or valid subdomains (e.g. cs.apex.edu).
    Rejects lookalikes (e.g. fakeapex.edu, apex.edu.evil.com) and naive substrings.
    """
    if not email or "@" not in email:
        return False
    email_domain = email.strip().lower().split("@")[-1]
    for d in allowed_domains:
        d_clean = d.strip().lower().lstrip("@")
        if email_domain == d_clean or email_domain.endswith(f".{d_clean}"):
            return True
    return False


def extract_subdomain_org_slug(host: str | None) -> str | None:
    """
    Extracts an organization slug from the host header according to the rule:
    {org_slug}.org.thelastdeploy.com (or local dev variants {org_slug}.org.localhost / {org_slug}.localhost)
    """
    if not host:
        return None
    cleaned = host.split(":")[0].strip().lower()

    if cleaned.endswith(".org.thelastdeploy.com"):
        sub = cleaned[: -len(".org.thelastdeploy.com")]
        return sub if sub else None

    if cleaned.endswith(".org.localhost"):
        sub = cleaned[: -len(".org.localhost")]
        return sub if sub else None

    # Dev convenience: e.g. jecrc.localhost (excluding app, api)
    if cleaned.endswith(".localhost") and cleaned != "localhost":
        sub = cleaned[: -len(".localhost")]
        if sub not in ("app", "api", "landing", "auth"):
            return sub

    return None


def generate_invitation_tokens() -> tuple[str, str, str]:
    """
    Generates a cryptographically secure random token, its SHA-256 hash, and a human-readable code.
    Returns: (raw_token, token_hash, invitation_code)
    """
    raw_token = secrets.token_urlsafe(32)
    token_hash = hashlib.sha256(raw_token.encode("utf-8")).hexdigest()

    # Friendly human-readable code: TLD-XXXX-XXXX
    alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
    part1 = "".join(secrets.choice(alphabet) for _ in range(4))
    part2 = "".join(secrets.choice(alphabet) for _ in range(4))
    invitation_code = f"TLD-{part1}-{part2}"

    return raw_token, token_hash, invitation_code


async def get_organization_invitation_expiry(
    db: AsyncSession,
    organization_id: int,
) -> datetime:
    """
    Retrieves the organization's configured invitation expiry policy (in days)
    and returns a UTC snapshot datetime.
    """
    settings_service = SettingsService()
    expiry_days = await settings_service.get_effective_setting_value(
        db, organization_id, "invitations.expiry_days"
    )
    try:
        days = int(expiry_days) if expiry_days is not None else 7
    except (ValueError, TypeError):
        days = 7

    days = max(1, min(days, 90))  # safe bounds: 1 to 90 days
    return datetime.now(timezone.utc) + timedelta(days=days)


async def create_organization_invitation(
    db: AsyncSession,
    organization_id: int,
    email: str,
    cohort_id: int | None = None,
    learning_path_id: int | None = None,
    created_by_user_id: int | None = None,
) -> tuple[OrganizationInvitation, str]:
    """
    Issues an individual single-use organization or cohort/learning-path invitation.
    Returns: (invitation_record, raw_token)
    """
    normalized_email = email.strip().lower()

    # 1. Validate organization
    org = await db.scalar(select(Organization).where(Organization.id == organization_id))
    if not org or org.status != "active":
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Organization not found or inactive")

    # 2. Validate cohort if provided
    cohort_name = None
    if cohort_id is not None:
        cohort = await db.scalar(
            select(Cohort).where(
                Cohort.id == cohort_id,
                Cohort.organization_id == organization_id,
            )
        )
        if not cohort:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cohort not found in this organization")
        cohort_name = cohort.name

    # 3. Validate learning path if provided
    learning_path_name = None
    if learning_path_id is not None:
        lp = await db.scalar(
            select(LearningPath).where(
                LearningPath.id == learning_path_id,
                LearningPath.organization_id == organization_id,
            )
        )
        if not lp:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Learning path not found in this organization")
        learning_path_name = lp.name

    # 4. Check domain enforcement setting if applicable
    settings_service = SettingsService()
    enforce_domain = await settings_service.get_effective_setting_value(
        db, organization_id, "security.enforce_domain_match"
    )
    if enforce_domain and org.type != "platform" and org.domains:
        valid_domains = [d.lower().strip() for d in org.domains]
        if not is_domain_eligible(normalized_email, valid_domains):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Email domain does not match organization verified domains: {valid_domains}",
            )

    # 5. Check if user is already an active member of this organization without cohort assignment
    if cohort_id is None:
        existing_user = await db.scalar(select(User).where(User.email == normalized_email))
        if existing_user:
            mem = await db.scalar(
                select(OrganizationMembership).where(
                    OrganizationMembership.organization_id == organization_id,
                    OrganizationMembership.user_id == existing_user.id,
                    OrganizationMembership.status == "active",
                )
            )
            if mem:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"User '{normalized_email}' is already an active member of this organization",
                )

    # 6. Check for active pending invitation for this exact scope
    existing_invite = await db.scalar(
        select(OrganizationInvitation).where(
            OrganizationInvitation.organization_id == organization_id,
            OrganizationInvitation.cohort_id == cohort_id,
            OrganizationInvitation.learning_path_id == learning_path_id,
            OrganizationInvitation.email == normalized_email,
            OrganizationInvitation.status == "pending",
            OrganizationInvitation.expires_at > datetime.now(timezone.utc),
            OrganizationInvitation.revoked_at.is_(None),
        )
    )
    if existing_invite:
        # Revoke old pending to issue fresh credentials cleanly
        existing_invite.status = "revoked"
        existing_invite.revoked_at = datetime.now(timezone.utc)
        existing_invite.revoked_by_user_id = created_by_user_id

    # 7. Generate secrets and snapshot expiry
    raw_token, token_hash, invitation_code = generate_invitation_tokens()
    expires_at = await get_organization_invitation_expiry(db, organization_id)

    invitation = OrganizationInvitation(
        organization_id=organization_id,
        cohort_id=cohort_id,
        learning_path_id=learning_path_id,
        email=normalized_email,
        token_hash=token_hash,
        invitation_code=invitation_code,
        status="pending",
        created_by_user_id=created_by_user_id,
        expires_at=expires_at,
    )
    db.add(invitation)
    await db.flush()

    # 8. Audit log
    await log_audit_event(
        db=db,
        action="invitation.created",
        entity_type="organization_invitation",
        entity_id=str(invitation.id),
        actor_user_id=created_by_user_id,
        organization_id=organization_id,
        metadata={
            "email": normalized_email,
            "cohort_id": cohort_id,
            "cohort_name": cohort_name,
            "learning_path_id": learning_path_id,
            "learning_path_name": learning_path_name,
            "expires_at": expires_at.isoformat(),
        },
    )

    return invitation, raw_token


async def resend_organization_invitation(
    db: AsyncSession,
    invitation_id: int,
    organization_id: int,
    actor_user_id: int,
) -> tuple[OrganizationInvitation, str]:
    """
    Resends an active pending invitation by renewing credentials and expiry
    while strictly preserving target email, scope, and organization.
    """
    invitation = await db.scalar(
        select(OrganizationInvitation).where(
            OrganizationInvitation.id == invitation_id,
            OrganizationInvitation.organization_id == organization_id,
        )
    )
    if not invitation:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Invitation not found")

    if invitation.status != "pending":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Cannot resend invitation with status '{invitation.status}'",
        )

    if invitation.expires_at <= datetime.now(timezone.utc):
        invitation.status = "expired"
        db.add(invitation)
        await db.commit()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot resend an expired invitation. Please create a new invitation.",
        )

    raw_token, token_hash, invitation_code = generate_invitation_tokens()
    new_expires_at = await get_organization_invitation_expiry(db, organization_id)

    invitation.token_hash = token_hash
    invitation.invitation_code = invitation_code
    invitation.expires_at = new_expires_at
    db.add(invitation)
    await db.flush()

    await log_audit_event(
        db=db,
        action="invitation.resent",
        entity_type="organization_invitation",
        entity_id=str(invitation.id),
        actor_user_id=actor_user_id,
        organization_id=organization_id,
        metadata={
            "email": invitation.email,
            "cohort_id": invitation.cohort_id,
            "learning_path_id": invitation.learning_path_id,
            "new_expires_at": new_expires_at.isoformat(),
        },
    )
    await db.commit()
    return invitation, raw_token


async def revoke_organization_invitation(
    db: AsyncSession,
    invitation_id: int,
    organization_id: int,
    revoker_user_id: int,
) -> OrganizationInvitation:
    """Revokes an active pending invitation."""
    invitation = await db.scalar(
        select(OrganizationInvitation).where(
            OrganizationInvitation.id == invitation_id,
            OrganizationInvitation.organization_id == organization_id,
        )
    )
    if not invitation:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Invitation not found")

    if invitation.status != "pending":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Cannot revoke invitation with status '{invitation.status}'",
        )

    invitation.status = "revoked"
    invitation.revoked_at = datetime.now(timezone.utc)
    invitation.revoked_by_user_id = revoker_user_id
    db.add(invitation)

    await log_audit_event(
        db=db,
        action="invitation.revoked",
        entity_type="organization_invitation",
        entity_id=str(invitation.id),
        actor_user_id=revoker_user_id,
        organization_id=organization_id,
        metadata={"email": invitation.email, "cohort_id": invitation.cohort_id},
    )
    await db.commit()
    return invitation


async def create_access_request(
    db: AsyncSession,
    organization_id: int,
    email: str,
) -> tuple[OrganizationAccessRequest | None, OrganizationInvitation | None, str | None, str]:
    """
    Submits an institutional access request.
    Validates domain eligibility against organization.domains.
    Depending on onboarding.access_approval_mode:
      - 'automatic': immediately issues invitation and returns (None, invitation, raw_token, 'automatic')
      - 'manual': queues access request and returns (access_request, None, None, 'manual')
    """
    normalized_email = email.strip().lower()

    org = await db.scalar(select(Organization).where(Organization.id == organization_id))
    if not org or org.status != "active":
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Organization not found or inactive")

    # Domain eligibility check using exact or valid subdomain matching
    valid_domains = [d.lower().strip() for d in (org.domains or [])]
    if not is_domain_eligible(normalized_email, valid_domains):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Email domain is not authorized for {org.name}. Authorized domains: {valid_domains}",
        )

    # Check approval mode
    settings_service = SettingsService()
    approval_mode = await settings_service.get_effective_setting_value(
        db, organization_id, "onboarding.access_approval_mode"
    )
    is_automatic = str(approval_mode).lower() == "automatic"

    if is_automatic:
        # Automatic approval -> issue invitation directly
        invitation, raw_token = await create_organization_invitation(
            db=db,
            organization_id=organization_id,
            email=normalized_email,
            cohort_id=None,
            created_by_user_id=None,
        )
        await db.commit()
        return None, invitation, raw_token, "automatic"

    # Manual approval -> Check existing pending request
    existing_pending = await db.scalar(
        select(OrganizationAccessRequest).where(
            OrganizationAccessRequest.organization_id == organization_id,
            OrganizationAccessRequest.email == normalized_email,
            OrganizationAccessRequest.status == "pending",
        )
    )
    if existing_pending:
        return existing_pending, None, None, "manual"

    req = OrganizationAccessRequest(
        organization_id=organization_id,
        email=normalized_email,
        status="pending",
    )
    db.add(req)
    await db.flush()

    await log_audit_event(
        db=db,
        action="access_request.created",
        entity_type="organization_access_request",
        entity_id=str(req.id),
        organization_id=organization_id,
        metadata={"email": normalized_email},
    )
    await db.commit()
    return req, None, None, "manual"


async def approve_access_request(
    db: AsyncSession,
    request_id: int,
    organization_id: int,
    reviewer_user_id: int,
) -> tuple[OrganizationAccessRequest, OrganizationInvitation, str]:
    """Approves a pending access request and issues an individual invitation."""
    req = await db.scalar(
        select(OrganizationAccessRequest).where(
            OrganizationAccessRequest.id == request_id,
            OrganizationAccessRequest.organization_id == organization_id,
        )
    )
    if not req:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Access request not found")

    if req.status != "pending":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Cannot approve request with status '{req.status}'",
        )

    # Issue invitation
    invitation, raw_token = await create_organization_invitation(
        db=db,
        organization_id=organization_id,
        email=req.email,
        cohort_id=None,
        created_by_user_id=reviewer_user_id,
    )

    req.status = "approved"
    req.reviewed_by_user_id = reviewer_user_id
    req.reviewed_at = datetime.now(timezone.utc)
    req.issued_invitation_id = invitation.id
    db.add(req)

    await log_audit_event(
        db=db,
        action="access_request.approved",
        entity_type="organization_access_request",
        entity_id=str(req.id),
        actor_user_id=reviewer_user_id,
        organization_id=organization_id,
        metadata={"email": req.email, "invitation_id": invitation.id},
    )
    await db.commit()
    return req, invitation, raw_token


async def reject_access_request(
    db: AsyncSession,
    request_id: int,
    organization_id: int,
    reviewer_user_id: int,
    reason: str | None = None,
) -> OrganizationAccessRequest:
    """Rejects a pending access request."""
    req = await db.scalar(
        select(OrganizationAccessRequest).where(
            OrganizationAccessRequest.id == request_id,
            OrganizationAccessRequest.organization_id == organization_id,
        )
    )
    if not req:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Access request not found")

    if req.status != "pending":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Cannot reject request with status '{req.status}'",
        )

    req.status = "rejected"
    req.reviewed_by_user_id = reviewer_user_id
    req.reviewed_at = datetime.now(timezone.utc)
    req.rejection_reason = reason
    db.add(req)

    await log_audit_event(
        db=db,
        action="access_request.rejected",
        entity_type="organization_access_request",
        entity_id=str(req.id),
        actor_user_id=reviewer_user_id,
        organization_id=organization_id,
        metadata={"email": req.email, "reason": reason},
    )
    await db.commit()
    return req


async def resolve_invitation_by_token_or_code(
    db: AsyncSession,
    token: str | None = None,
    code: str | None = None,
    for_update: bool = False,
) -> OrganizationInvitation:
    """Resolves an active pending invitation by raw token or human code."""
    if not token and not code:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Either invitation token or code is required")

    stmt = select(OrganizationInvitation)
    if token:
        clean_token = token.strip()
        token_hash = hashlib.sha256(clean_token.encode("utf-8")).hexdigest()
        stmt = stmt.where(OrganizationInvitation.token_hash == token_hash)
    elif code:
        clean_code = code.strip().upper()
        stmt = stmt.where(OrganizationInvitation.invitation_code == clean_code)

    if for_update:
        stmt = stmt.with_for_update()

    invitation = await db.scalar(stmt)
    if not invitation:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Invitation not found or invalid")

    now = datetime.now(timezone.utc)
    if invitation.status == "revoked":
        raise HTTPException(status_code=status.HTTP_410_GONE, detail="This invitation has been revoked")

    if invitation.status == "accepted":
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="This invitation has already been redeemed")

    if invitation.expires_at <= now:
        invitation.status = "expired"
        db.add(invitation)
        await db.commit()
        raise HTTPException(status_code=status.HTTP_410_GONE, detail="This invitation has expired")

    return invitation


def create_onboarding_token(invitation_id: int, email: str, organization_id: int) -> str:
    """Creates a short-lived restricted JWT strictly for setting an account password."""
    now = datetime.now(timezone.utc)
    payload = {
        "sub": "onboarding",
        "scope": "invitation_password_setup",
        "invitation_id": invitation_id,
        "email": email,
        "organization_id": organization_id,
        "iat": now,
        "exp": now + timedelta(minutes=15),
    }
    return jwt.encode(payload, settings.SECRET_KEY, algorithm="HS256")


def decode_onboarding_token(token: str) -> dict[str, Any]:
    """Validates and decodes the restricted onboarding token."""
    payload = decode_token_payload(token)
    if not payload or payload.get("scope") != "invitation_password_setup":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired onboarding session. Please re-open your invitation link.",
        )
    return payload


async def ensure_organization_and_cohort_membership(
    db: AsyncSession,
    organization_id: int,
    user_id: int,
    cohort_id: int | None = None,
) -> tuple[OrganizationMembership, CohortMembership | None]:
    """
    Idempotently ensures the user is an active member in the organization
    and (if cohort_id is set) in the cohort.
    """
    # 1. Organization Membership
    mem = await db.scalar(
        select(OrganizationMembership).where(
            OrganizationMembership.organization_id == organization_id,
            OrganizationMembership.user_id == user_id,
        )
    )
    if not mem:
        from app.services import resolve_default_org_role
        learner_role = await resolve_default_org_role(db, organization_id, preferred_slug="learner")
        if not learner_role:
            raise ValueError(f"No roles configured for organization {organization_id}")
        mem = OrganizationMembership(
            organization_id=organization_id,
            user_id=user_id,
            role_id=learner_role.id,
            status="active",
            total_xp=0,
            unverified_xp=0,
        )
        db.add(mem)
        await db.flush()
    elif mem.status != "active":
        mem.status = "active"
        db.add(mem)
        await db.flush()

    # 2. Cohort Membership if specified
    cohort_mem = None
    if cohort_id:
        cohort_mem = await db.scalar(
            select(CohortMembership).where(
                CohortMembership.cohort_id == cohort_id,
                CohortMembership.organization_membership_id == mem.id,
            )
        )
        if not cohort_mem:
            cohort_mem = CohortMembership(
                cohort_id=cohort_id,
                organization_id=organization_id,
                organization_membership_id=mem.id,
            )
            db.add(cohort_mem)
            await db.flush()

    return mem, cohort_mem


async def process_bulk_invitations_csv(
    db: AsyncSession,
    organization_id: int,
    cohort_id: int | None,
    csv_bytes: bytes,
    created_by_user_id: int,
) -> tuple[int, int, int, list[dict[str, Any]], list[tuple[str, str, str | None, datetime]]]:
    """
    Parses a CSV containing an 'email' column, validates each address and optional cohort/learning_path,
    creates individual invitations, and returns a detailed report.
    Returns: (total_processed, created_count, skipped_count, results_summary, pending_emails_to_dispatch)
    """
    if len(csv_bytes) > 5 * 1024 * 1024:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="CSV file exceeds maximum allowed size (5MB)")

    try:
        text = csv_bytes.decode("utf-8-sig")
    except UnicodeDecodeError:
        text = csv_bytes.decode("latin-1")

    reader = csv.DictReader(io.StringIO(text))
    if not reader.fieldnames:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Uploaded file is empty")

    email_col = next((c for c in reader.fieldnames if c.strip().lower() in ("email", "e-mail", "student_email")), None)
    if not email_col:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="CSV must contain an 'email' header column")

    cohort_col = next((c for c in reader.fieldnames if c.strip().lower() in ("cohort", "cohort_id", "cohort_name", "cohort_slug")), None)
    lp_col = next((c for c in reader.fieldnames if c.strip().lower() in ("learning_path", "learning_path_id", "path", "path_slug")), None)

    results: list[dict[str, Any]] = []
    seen_in_batch = set()
    created_count = 0
    skipped_count = 0
    pending_emails: list[tuple[str, str, str | None, datetime]] = []

    for row in reader:
        if not any(v.strip() for v in row.values() if v):
            continue

        raw_email = row.get(email_col, "").strip()
        if not raw_email:
            continue

        normalized = raw_email.lower()
        if normalized in seen_in_batch:
            skipped_count += 1
            results.append({"email": raw_email, "status": "skipped_duplicate", "detail": "Duplicate email in uploaded file"})
            continue

        seen_in_batch.add(normalized)

        if not EMAIL_REGEX.match(normalized):
            skipped_count += 1
            results.append({"email": raw_email, "status": "invalid_format", "detail": "Invalid email address format"})
            continue

        # Resolve cohort for row
        row_cohort_id = cohort_id
        if cohort_col and row.get(cohort_col, "").strip():
            val = row[cohort_col].strip()
            # Match by id or name
            cohort_query = select(Cohort).where(Cohort.organization_id == organization_id)
            if val.isdigit():
                cohort_query = cohort_query.where(Cohort.id == int(val))
            else:
                cohort_query = cohort_query.where(func.lower(Cohort.name) == val.lower())
            found_cohort = await db.scalar(cohort_query)
            if not found_cohort:
                skipped_count += 1
                results.append({"email": normalized, "status": "error", "detail": f"Unknown cohort '{val}' in this organization"})
                continue
            row_cohort_id = found_cohort.id

        # Resolve learning path for row
        row_lp_id = None
        if lp_col and row.get(lp_col, "").strip():
            lp_val = row[lp_col].strip()
            lp_query = select(LearningPath).where(LearningPath.organization_id == organization_id)
            if lp_val.isdigit():
                lp_query = lp_query.where(LearningPath.id == int(lp_val))
            else:
                lp_query = lp_query.where(
                    (func.lower(LearningPath.slug) == lp_val.lower()) | (func.lower(LearningPath.name) == lp_val.lower())
                )
            found_lp = await db.scalar(lp_query)
            if not found_lp:
                skipped_count += 1
                results.append({"email": normalized, "status": "error", "detail": f"Unknown learning path '{lp_val}' in this organization"})
                continue
            row_lp_id = found_lp.id

        # Check existing member
        user = await db.scalar(select(User).where(User.email == normalized))
        if user:
            mem = await db.scalar(
                select(OrganizationMembership).where(
                    OrganizationMembership.organization_id == organization_id,
                    OrganizationMembership.user_id == user.id,
                    OrganizationMembership.status == "active",
                )
            )
            if mem:
                if row_cohort_id is None:
                    skipped_count += 1
                    results.append({"email": normalized, "status": "skipped_member", "detail": "User is already an active member of this organization"})
                    continue
                else:
                    cm = await db.scalar(
                        select(CohortMembership).where(
                            CohortMembership.cohort_id == row_cohort_id,
                            CohortMembership.organization_membership_id == mem.id,
                        )
                    )
                    if cm:
                        skipped_count += 1
                        results.append({"email": normalized, "status": "skipped_member", "detail": f"User is already a member of cohort ID {row_cohort_id}"})
                        continue

        # Check existing active pending invitation
        existing_pending = await db.scalar(
            select(OrganizationInvitation).where(
                OrganizationInvitation.organization_id == organization_id,
                OrganizationInvitation.cohort_id == row_cohort_id,
                OrganizationInvitation.learning_path_id == row_lp_id,
                OrganizationInvitation.email == normalized,
                OrganizationInvitation.status == "pending",
                OrganizationInvitation.expires_at > datetime.now(timezone.utc),
                OrganizationInvitation.revoked_at.is_(None),
            )
        )
        if existing_pending:
            skipped_count += 1
            results.append({"email": normalized, "status": "skipped_pending", "detail": "Active pending invitation already exists for this email"})
            continue

        try:
            invitation, raw_token = await create_organization_invitation(
                db=db,
                organization_id=organization_id,
                email=normalized,
                cohort_id=row_cohort_id,
                learning_path_id=row_lp_id,
                created_by_user_id=created_by_user_id,
            )
            created_count += 1
            results.append({"email": normalized, "status": "created", "detail": f"Invitation ID {invitation.id} issued"})
            pending_emails.append((normalized, raw_token, invitation.invitation_code, invitation.expires_at))
        except HTTPException as e:
            skipped_count += 1
            results.append({"email": normalized, "status": "error", "detail": e.detail})
        except Exception as e:
            skipped_count += 1
            results.append({"email": normalized, "status": "error", "detail": str(e)})

    await db.commit()

    # Log bulk audit event
    await log_audit_event(
        db=db,
        action="invitation.bulk_created",
        entity_type="organization",
        entity_id=str(organization_id),
        actor_user_id=created_by_user_id,
        organization_id=organization_id,
        metadata={
            "total_processed": len(seen_in_batch),
            "created_count": created_count,
            "skipped_count": skipped_count,
            "cohort_id": cohort_id,
        },
    )

    return len(seen_in_batch), created_count, skipped_count, results, pending_emails
