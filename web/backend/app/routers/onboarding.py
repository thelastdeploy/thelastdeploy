# web/backend/app/routers/onboarding.py

import logging
from datetime import datetime, timezone
from fastapi import APIRouter, Depends, HTTPException, status, BackgroundTasks, Request
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.dependencies import get_db, get_request_organization
from app.models import (
    User,
    Organization,
    OrganizationInvitation,
    OrganizationAccessRequest,
    Cohort,
)
from app.schemas import (
    OrganizationPublicInfoResponse,
    AccessRequestCreate,
    InvitationVerifyRequest,
    InvitationVerifyResponse,
    InvitationRedeemRequest,
    OnboardingCompleteSetupRequest,
    TokenResponse,
    MessageResponse,
)
from app.auth import hash_password
from app.routers.auth import _create_session
from app.settings.service import SettingsService
from app.email import send_invitation_email
from app.config import settings
from app.services import log_audit_event
from app.onboarding.service import (
    create_access_request,
    resolve_invitation_by_token_or_code,
    create_onboarding_token,
    decode_onboarding_token,
    ensure_organization_and_cohort_membership,
)

router = APIRouter(prefix="/onboarding", tags=["onboarding"])
logger = logging.getLogger(__name__)


@router.get("/organization-info", response_model=OrganizationPublicInfoResponse)
async def get_organization_info(
    organization: Organization = Depends(get_request_organization),
    db: AsyncSession = Depends(get_db),
):
    """
    Publicly returns the resolved organization's identity, verified domains,
    and configured access approval mode.
    """
    settings_service = SettingsService()
    approval_mode = await settings_service.get_effective_setting_value(
        db, organization.id, "onboarding.access_approval_mode"
    )
    mode = str(approval_mode).lower() if approval_mode else "automatic"

    return OrganizationPublicInfoResponse(
        id=organization.id,
        name=organization.name,
        slug=organization.slug,
        type=organization.type,
        domains=organization.domains or [],
        approval_mode=mode,
    )


@router.post("/access-request")
async def submit_access_request(
    body: AccessRequestCreate,
    background_tasks: BackgroundTasks,
    organization: Organization = Depends(get_request_organization),
    db: AsyncSession = Depends(get_db),
):
    """
    Submits an institutional domain-based access request.
    If 'automatic' mode is active, an individual invitation is generated and emailed immediately.
    If 'manual' mode is active, the request is queued for administrator review.
    """
    req, invitation, raw_token, mode = await create_access_request(
        db=db,
        organization_id=organization.id,
        email=body.email,
    )

    if mode == "automatic" and invitation and raw_token:
        # Build invitation URL
        subdomain_base = (
            f"http://{organization.slug}.org.localhost:9000"
            if settings.ENVIRONMENT.lower() == "development"
            else f"https://{organization.slug}.org.thelastdeploy.com"
        )
        invite_url = f"{subdomain_base}/join?token={raw_token}"
        send_invitation_email(
            email=invitation.email,
            org_name=organization.name,
            invite_url=invite_url,
            invite_code=invitation.invitation_code,
            cohort_name=None,
            expires_at=invitation.expires_at,
            background_tasks=background_tasks,
        )
        return {
            "status": "approved",
            "mode": "automatic",
            "detail": f"An individual single-use invitation code and link have been emailed to {body.email}.",
        }

    return {
        "status": "pending",
        "mode": "manual",
        "detail": f"Access request submitted. An administrator for {organization.name} will review your application.",
    }


@router.post("/invitations/verify", response_model=InvitationVerifyResponse)
async def verify_invitation(
    body: InvitationVerifyRequest,
    db: AsyncSession = Depends(get_db),
):
    """
    Verifies an invitation token or human-entered code without consuming it.
    Returns status, organization details, and whether password setup is required.
    """
    invitation = await resolve_invitation_by_token_or_code(
        db=db,
        token=body.token,
        code=body.code,
        for_update=False,
    )

    # Resolve organization & cohort details
    org = await db.scalar(select(Organization).where(Organization.id == invitation.organization_id))
    cohort_name = None
    if invitation.cohort_id:
        cohort = await db.scalar(select(Cohort).where(Cohort.id == invitation.cohort_id))
        if cohort:
            cohort_name = cohort.name

    # Check if recipient already exists as a global user
    user = await db.scalar(select(User).where(User.email == invitation.email))
    is_existing = user is not None

    return InvitationVerifyResponse(
        valid=True,
        email=invitation.email,
        organization_name=org.name if org else "The Last Deploy",
        organization_slug=org.slug if org else "tld",
        cohort_name=cohort_name,
        is_existing_user=is_existing,
        requires_password_setup=not is_existing,
    )


@router.post("/invitations/redeem")
async def redeem_invitation(
    body: InvitationRedeemRequest,
    request: Request,
    db: AsyncSession = Depends(get_db),
):
    """
    Redeems an invitation atomically.
    - If recipient email exists in users: consumes invitation, creates org/cohort membership, establishes session.
    - If recipient email does NOT exist: generates restricted onboarding session token for password setup.
    """
    invitation = await resolve_invitation_by_token_or_code(
        db=db,
        token=body.token,
        code=body.code,
        for_update=True,
    )

    user = await db.scalar(select(User).where(User.email == invitation.email))

    if not user:
        # Case A: New user -> issue short-lived onboarding token
        onboarding_token = create_onboarding_token(
            invitation_id=invitation.id,
            email=invitation.email,
            organization_id=invitation.organization_id,
        )
        return {
            "requires_password_setup": True,
            "onboarding_token": onboarding_token,
            "email": invitation.email,
            "organization_id": invitation.organization_id,
            "cohort_id": invitation.cohort_id,
        }

    # Case B: Existing user -> Redeem immediately and transition status atomically
    mem, cohort_mem = await ensure_organization_and_cohort_membership(
        db=db,
        organization_id=invitation.organization_id,
        user_id=user.id,
        cohort_id=invitation.cohort_id,
    )

    invitation.status = "accepted"
    invitation.redeemed_at = datetime.now(timezone.utc)
    invitation.redeemed_by_user_id = user.id
    db.add(invitation)

    await log_audit_event(
        db=db,
        action="invitation.redeemed",
        entity_type="organization_invitation",
        entity_id=str(invitation.id),
        actor_user_id=user.id,
        organization_id=invitation.organization_id,
        metadata={
            "email": invitation.email,
            "cohort_id": invitation.cohort_id,
            "user_id": user.id,
            "is_new_user": False,
        },
    )
    await db.commit()

    session, access_token = await _create_session(db, user, client_type="web", request=request)
    return {
        "status": "accepted",
        "requires_password_setup": False,
        "access_token": access_token,
        "device_key": session.device_key,
        "token_type": "bearer",
        "redirect_to": f"/dashboard?org={invitation.organization_id}",
    }


@router.post("/invitations/complete-setup")
async def complete_onboarding_setup(
    body: OnboardingCompleteSetupRequest,
    request: Request,
    db: AsyncSession = Depends(get_db),
):
    """
    Completes password setup for a new student invited to an organization or cohort.
    Consumes the restricted onboarding token and finalizes the invitation atomically.
    """
    payload = decode_onboarding_token(body.onboarding_token)
    invitation_id = payload["invitation_id"]
    email = payload["email"]
    organization_id = payload["organization_id"]

    # Lock invitation row
    invitation = await db.scalar(
        select(OrganizationInvitation)
        .where(OrganizationInvitation.id == invitation_id)
        .with_for_update()
    )
    if not invitation:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Invitation record not found")

    if invitation.status != "pending":
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=f"Invitation has already been {invitation.status}",
        )

    if invitation.expires_at <= datetime.now(timezone.utc):
        invitation.status = "expired"
        db.add(invitation)
        await db.commit()
        raise HTTPException(status_code=status.HTTP_410_GONE, detail="Invitation has expired")

    # Check username availability
    cleaned_username = body.username.strip()
    if len(cleaned_username) < 3:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Username must be at least 3 characters")

    existing_username = await db.scalar(select(User).where(User.username == cleaned_username))
    if existing_username:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Username is already taken")

    # 1. Create global User
    user = User(
        email=email,
        username=cleaned_username,
        password_hash=hash_password(body.password),
        is_verified=True,  # Verified via invitation link possession
    )
    db.add(user)
    await db.flush()

    # 2. Create organization membership and cohort assignment
    mem, cohort_mem = await ensure_organization_and_cohort_membership(
        db=db,
        organization_id=organization_id,
        user_id=user.id,
        cohort_id=invitation.cohort_id,
    )

    # 3. Finalize invitation
    invitation.status = "accepted"
    invitation.redeemed_at = datetime.now(timezone.utc)
    invitation.redeemed_by_user_id = user.id
    db.add(invitation)

    await log_audit_event(
        db=db,
        action="invitation.redeemed",
        entity_type="organization_invitation",
        entity_id=str(invitation.id),
        actor_user_id=user.id,
        organization_id=organization_id,
        metadata={
            "email": email,
            "cohort_id": invitation.cohort_id,
            "user_id": user.id,
            "is_new_user": True,
        },
    )
    await db.commit()
    await db.refresh(user)

    session, access_token = await _create_session(db, user, client_type="web", request=request)
    return {
        "status": "accepted",
        "requires_password_setup": False,
        "access_token": access_token,
        "device_key": session.device_key,
        "token_type": "bearer",
        "redirect_to": f"/dashboard?org={organization_id}",
    }
