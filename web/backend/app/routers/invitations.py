# web/backend/app/routers/invitations.py

import logging
from datetime import datetime, timezone
from fastapi import APIRouter, Depends, HTTPException, status, BackgroundTasks, UploadFile, File, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, desc

from app.dependencies import (
    get_db,
    get_current_user,
    get_current_organization,
    require_permission,
    require_any_permission,
)
from app.settings.service import SettingsService
from app.models import (
    User,
    Organization,
    OrganizationMembership,
    OrganizationInvitation,
    OrganizationAccessRequest,
    Cohort,
)
from app.schemas import (
    InvitationResponse,
    InvitationCreateRequest,
    InvitationStatsResponse,
    BulkInvitationResponse,
    AccessRequestResponse,
    AccessRequestRejectPayload,
    MessageResponse,
)
from app.email import send_invitation_email
from app.config import settings
from app.onboarding.service import (
    create_organization_invitation,
    resend_organization_invitation,
    revoke_organization_invitation,
    approve_access_request,
    reject_access_request,
    process_bulk_invitations_csv,
)

router = APIRouter(prefix="/organizations", tags=["invitations"])
logger = logging.getLogger(__name__)


def _get_invite_url(org_slug: str, raw_token: str) -> str:
    subdomain_base = (
        f"http://{org_slug}.org.localhost:9000"
        if settings.ENVIRONMENT.lower() == "development"
        else f"https://{org_slug}.org.thelastdeploy.com"
    )
    return f"{subdomain_base}/join?token={raw_token}"


@router.get("/invitations/stats", response_model=InvitationStatsResponse)
async def get_invitation_stats(
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
    _perm: User = Depends(require_permission("members.view")),
):
    """Returns overview counts of invitations and access requests for the dashboard."""
    organization, _ = org_and_mem
    now = datetime.now(timezone.utc)

    # 1. Total, Pending, Accepted, Revoked, Expired
    total = await db.scalar(
        select(func.count(OrganizationInvitation.id)).where(OrganizationInvitation.organization_id == organization.id)
    ) or 0

    pending = await db.scalar(
        select(func.count(OrganizationInvitation.id)).where(
            OrganizationInvitation.organization_id == organization.id,
            OrganizationInvitation.status == "pending",
            OrganizationInvitation.expires_at > now,
        )
    ) or 0

    accepted = await db.scalar(
        select(func.count(OrganizationInvitation.id)).where(
            OrganizationInvitation.organization_id == organization.id,
            OrganizationInvitation.status == "accepted",
        )
    ) or 0

    revoked = await db.scalar(
        select(func.count(OrganizationInvitation.id)).where(
            OrganizationInvitation.organization_id == organization.id,
            OrganizationInvitation.status == "revoked",
        )
    ) or 0

    expired = await db.scalar(
        select(func.count(OrganizationInvitation.id)).where(
            OrganizationInvitation.organization_id == organization.id,
            (OrganizationInvitation.status == "expired")
            | (
                (OrganizationInvitation.status == "pending")
                & (OrganizationInvitation.expires_at <= now)
            ),
        )
    ) or 0

    pending_reqs = await db.scalar(
        select(func.count(OrganizationAccessRequest.id)).where(
            OrganizationAccessRequest.organization_id == organization.id,
            OrganizationAccessRequest.status == "pending",
        )
    ) or 0

    return InvitationStatsResponse(
        total_invitations=total,
        pending_invitations=pending,
        accepted_invitations=accepted,
        expired_invitations=expired,
        revoked_invitations=revoked,
        pending_access_requests=pending_reqs,
    )


@router.get("/invitations", response_model=list[InvitationResponse])
async def list_invitations(
    status_filter: str | None = Query(None, alias="status"),
    cohort_id: int | None = Query(None),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
    _perm: User = Depends(require_permission("members.view")),
):
    """Lists organization invitations with optional status and cohort filters."""
    organization, _ = org_and_mem
    stmt = select(OrganizationInvitation).where(OrganizationInvitation.organization_id == organization.id)

    if status_filter:
        stmt = stmt.where(OrganizationInvitation.status == status_filter.lower())
    if cohort_id:
        stmt = stmt.where(OrganizationInvitation.cohort_id == cohort_id)

    stmt = stmt.order_by(desc(OrganizationInvitation.created_at)).offset(offset).limit(limit)
    res = await db.execute(stmt)
    invites = res.scalars().all()

    # Automatically check expired state for display
    now = datetime.now(timezone.utc)
    for inv in invites:
        if inv.status == "pending" and inv.expires_at <= now:
            inv.status = "expired"

    return invites


@router.post("/invitations", response_model=InvitationResponse)
async def create_invitation(
    body: InvitationCreateRequest,
    background_tasks: BackgroundTasks,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: User = Depends(require_any_permission("invitations.manage", "members.manage")),
):
    """Issues an individual organization invitation and sends an email."""
    organization, _ = org_and_mem

    cohort_name = None
    if body.cohort_id:
        cohort_invites_enabled = await SettingsService.get_effective_setting(db, organization.id, "cohorts.invitations_enabled")
        if cohort_invites_enabled is False:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Cohort invitations are disabled for this organization.",
            )
        cohort = await db.scalar(select(Cohort).where(Cohort.id == body.cohort_id, Cohort.organization_id == organization.id))
        if not cohort:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cohort not found in this organization")
        cohort_name = cohort.name

    invitation, raw_token = await create_organization_invitation(
        db=db,
        organization_id=organization.id,
        email=body.email,
        cohort_id=body.cohort_id,
        learning_path_id=body.learning_path_id,
        created_by_user_id=current_user.id,
    )
    await db.commit()

    # Dispatch email
    invite_url = _get_invite_url(organization.slug, raw_token)
    send_invitation_email(
        email=invitation.email,
        org_name=organization.name,
        invite_url=invite_url,
        invite_code=invitation.invitation_code,
        cohort_name=cohort_name,
        expires_at=invitation.expires_at,
        background_tasks=background_tasks,
    )

    return invitation


@router.post("/invitations/{invitation_id}/resend", response_model=InvitationResponse)
async def resend_invitation_endpoint(
    invitation_id: int,
    background_tasks: BackgroundTasks,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: User = Depends(require_permission("members.manage")),
):
    """Resends an active pending invitation with fresh credentials."""
    organization, _ = org_and_mem
    invitation, raw_token = await resend_organization_invitation(
        db=db,
        invitation_id=invitation_id,
        organization_id=organization.id,
        actor_user_id=current_user.id,
    )

    cohort_name = None
    if invitation.cohort_id:
        cohort = await db.scalar(select(Cohort).where(Cohort.id == invitation.cohort_id))
        if cohort:
            cohort_name = cohort.name

    invite_url = _get_invite_url(organization.slug, raw_token)
    send_invitation_email(
        email=invitation.email,
        org_name=organization.name,
        invite_url=invite_url,
        invite_code=invitation.invitation_code,
        cohort_name=cohort_name,
        expires_at=invitation.expires_at,
        background_tasks=background_tasks,
    )

    return invitation


@router.post("/invitations/bulk", response_model=BulkInvitationResponse)
async def upload_bulk_invitations(
    file: UploadFile = File(...),
    cohort_id: int | None = Query(None),
    background_tasks: BackgroundTasks = BackgroundTasks(),
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: User = Depends(require_permission("members.manage")),
):
    """
    Parses an uploaded CSV file containing an 'email' column and issues invitations in batch.
    Returns per-row outcome summary and dispatches emails via background tasks.
    """
    organization, _ = org_and_mem
    cohort_name = None
    if cohort_id:
        cohort = await db.scalar(select(Cohort).where(Cohort.id == cohort_id, Cohort.organization_id == organization.id))
        if not cohort:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cohort not found in this organization")
        cohort_name = cohort.name

    contents = await file.read()
    total, created, skipped, results, pending_emails = await process_bulk_invitations_csv(
        db=db,
        organization_id=organization.id,
        cohort_id=cohort_id,
        csv_bytes=contents,
        created_by_user_id=current_user.id,
    )

    # Dispatch emails asynchronously in background
    for em, raw_token, code, exp in pending_emails:
        invite_url = _get_invite_url(organization.slug, raw_token)
        send_invitation_email(
            email=em,
            org_name=organization.name,
            invite_url=invite_url,
            invite_code=code,
            cohort_name=cohort_name,
            expires_at=exp,
            background_tasks=background_tasks,
        )

    return BulkInvitationResponse(
        total_processed=total,
        created_count=created,
        skipped_count=skipped,
        results=results,
    )


@router.post("/invitations/{invitation_id}/revoke", response_model=MessageResponse)
async def revoke_invitation_endpoint(
    invitation_id: int,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: User = Depends(require_permission("members.manage")),
):
    """Revokes an active pending invitation."""
    organization, _ = org_and_mem
    await revoke_organization_invitation(
        db=db,
        invitation_id=invitation_id,
        organization_id=organization.id,
        revoker_user_id=current_user.id,
    )
    return MessageResponse(detail="Invitation successfully revoked.")


@router.get("/access-requests", response_model=list[AccessRequestResponse])
async def list_access_requests(
    status_filter: str | None = Query(None, alias="status"),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
    _perm: User = Depends(require_permission("members.view")),
):
    """Lists organization access requests submitted via domain eligibility."""
    organization, _ = org_and_mem
    stmt = select(OrganizationAccessRequest).where(OrganizationAccessRequest.organization_id == organization.id)

    if status_filter:
        stmt = stmt.where(OrganizationAccessRequest.status == status_filter.lower())

    stmt = stmt.order_by(desc(OrganizationAccessRequest.requested_at)).offset(offset).limit(limit)
    res = await db.execute(stmt)
    return res.scalars().all()


@router.post("/access-requests/{request_id}/approve")
async def approve_access_request_endpoint(
    request_id: int,
    background_tasks: BackgroundTasks,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: User = Depends(require_permission("members.manage")),
):
    """Approves an institutional access request and issues an individual invitation."""
    organization, _ = org_and_mem
    req, invitation, raw_token = await approve_access_request(
        db=db,
        request_id=request_id,
        organization_id=organization.id,
        reviewer_user_id=current_user.id,
    )

    invite_url = _get_invite_url(organization.slug, raw_token)
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
        "detail": f"Access request approved. Invitation sent to {req.email}.",
        "invitation_id": invitation.id,
    }


@router.post("/access-requests/{request_id}/reject", response_model=MessageResponse)
async def reject_access_request_endpoint(
    request_id: int,
    body: AccessRequestRejectPayload,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: User = Depends(require_permission("members.manage")),
):
    """Rejects an access request with an optional reason."""
    organization, _ = org_and_mem
    await reject_access_request(
        db=db,
        request_id=request_id,
        organization_id=organization.id,
        reviewer_user_id=current_user.id,
        reason=body.reason,
    )
    return MessageResponse(detail="Access request rejected.")


# --- Cohort Specific Invitation Endpoints (cohorts.manage) ---

@router.get("/cohorts/{cohort_id}/invitations", response_model=list[InvitationResponse])
async def list_cohort_invitations(
    cohort_id: int,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
    _perm: User = Depends(require_permission("cohorts.manage")),
):
    """Lists invitations specific to a cohort."""
    organization, _ = org_and_mem
    cohort = await db.scalar(select(Cohort).where(Cohort.id == cohort_id, Cohort.organization_id == organization.id))
    if not cohort:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cohort not found")

    stmt = (
        select(OrganizationInvitation)
        .where(
            OrganizationInvitation.organization_id == organization.id,
            OrganizationInvitation.cohort_id == cohort_id,
        )
        .order_by(desc(OrganizationInvitation.created_at))
    )
    res = await db.execute(stmt)
    return res.scalars().all()


@router.post("/cohorts/{cohort_id}/invitations", response_model=InvitationResponse)
async def create_cohort_invitation(
    cohort_id: int,
    body: InvitationCreateRequest,
    background_tasks: BackgroundTasks,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: User = Depends(require_permission("cohorts.manage")),
):
    """Issues an invitation directly into a specific cohort."""
    organization, _ = org_and_mem
    cohort_invites_enabled = await SettingsService.get_effective_setting(db, organization.id, "cohorts.invitations_enabled")
    if cohort_invites_enabled is False:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Cohort invitations are disabled for this organization.",
        )
    cohort = await db.scalar(select(Cohort).where(Cohort.id == cohort_id, Cohort.organization_id == organization.id))
    if not cohort:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cohort not found in this organization")

    invitation, raw_token = await create_organization_invitation(
        db=db,
        organization_id=organization.id,
        email=body.email,
        cohort_id=cohort_id,
        created_by_user_id=current_user.id,
    )
    await db.commit()

    invite_url = _get_invite_url(organization.slug, raw_token)
    send_invitation_email(
        email=invitation.email,
        org_name=organization.name,
        invite_url=invite_url,
        invite_code=invitation.invitation_code,
        cohort_name=cohort.name,
        expires_at=invitation.expires_at,
        background_tasks=background_tasks,
    )

    return invitation
