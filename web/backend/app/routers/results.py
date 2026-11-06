# web/backend/app/routers/results.py

import hashlib
import hmac
import logging
from datetime import datetime, timezone
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from app.dependencies import get_db, get_optional_user, get_optional_session
from app.models import Lab, LabProgress, User, UserSession, SectionProgress, Module, Section, OrganizationMembership, Organization
from app.schemas import ResultRequest, ResultResponse
from app.services import recalculate_and_update_user_xp, check_and_track_module_completion
from app.analytics import analytics, AnalyticsEvent

router = APIRouter()
logger = logging.getLogger(__name__)


def _verify_signature(body: ResultRequest, device_key: str) -> bool:
    """
    Verify HMAC-SHA256 signature using the user's per-device key.
    Payload format: lab_id:section_id:passed:output:validator_hash:timestamp (RFC3339 UTC)
    """
    if not body.signature or not body.ran_at:
        return False

    timestamp = body.ran_at.astimezone(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    passed_str = "true" if body.passed else "false"
    output_str = body.output or ""
    validator_hash_str = body.validator_hash or ""

    payload = f"{body.lab_id}:{body.section_id}:{passed_str}:{output_str}:{validator_hash_str}:{timestamp}"

    expected = hmac.new(
        device_key.encode(),
        payload.encode(),
        hashlib.sha256,
    ).hexdigest()

    return hmac.compare_digest(expected, body.signature)


@router.post("/results", response_model=ResultResponse)
async def submit_result(
    body: ResultRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User | None = Depends(get_optional_user),
    current_session: UserSession | None = Depends(get_optional_session),
):
    # 1. Look up lab by globally unique lab_id
    result = await db.execute(
        select(Lab).where(Lab.id == body.lab_id)
    )
    lab = result.scalar_one_or_none()
    if not lab:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Lab not found")

    # 1.5. Validator hash verification
    if lab.validator_hash:
        if not body.validator_hash or body.validator_hash != lab.validator_hash:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Validator script mismatch. The local validator script has been modified or is out of date. Please run 'tld sync' to update.",
            )

    # 2. Signature verification — requires authenticated user with device_key
    if body.signature:
        if not current_user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Authentication required to submit signed results",
            )
        signing_key = current_session.device_key if current_session and current_session.device_key else None
        if not signing_key and current_user:
            s_stmt = (
                select(UserSession.device_key)
                .where(
                    UserSession.user_id == current_user.id,
                    UserSession.revoked_at.is_(None),
                    UserSession.device_key.isnot(None),
                )
                .order_by(UserSession.created_at.desc())
                .limit(1)
            )
            s_res = await db.execute(s_stmt)
            signing_key = s_res.scalar_one_or_none()

        if not signing_key:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="No device key found — please log in again with tld login",
            )
        if not _verify_signature(body, signing_key):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid signature",
            )

    # 3. If not passed, return early — no XP
    if not body.passed:
        return ResultResponse(xp_awarded=0)

    # 4. Unauthenticated — return XP value but don't persist
    if not current_user:
        return ResultResponse(xp_awarded=lab.xp)

    # 5. Determine user's active membership(s)
    memberships = (await db.scalars(
        select(OrganizationMembership).where(
            OrganizationMembership.user_id == current_user.id,
            OrganizationMembership.status != "removed",
        )
    )).all()

    if not memberships:
        plat_org = await db.scalar(select(Organization).where(Organization.is_platform == True))
        plat_org_id = plat_org.id if plat_org else 1
        default_mem = OrganizationMembership(
            organization_id=plat_org_id,
            user_id=current_user.id,
            status="active",
        )
        db.add(default_mem)
        await db.flush()
        memberships = [default_mem]

    # Check if already completed in any of the user's active memberships
    mem_ids = [m.id for m in memberships]
    existing = await db.scalar(
        select(LabProgress.id).where(
            LabProgress.organization_membership_id.in_(mem_ids),
            LabProgress.lab_id == body.lab_id,
        )
    )

    if existing:
        return ResultResponse(xp_awarded=0)

    # 6. First completion — award progress to all memberships
    for m in memberships:
        db.add(LabProgress(
            organization_membership_id=m.id,
            lab_id=body.lab_id,
            xp_awarded=lab.xp,
        ))

    await db.flush()

    # Recalculate true total XP by summing database entries for the lab's owner organization
    await recalculate_and_update_user_xp(current_user, db, organization_id=lab.owner_organization_id)

    await db.commit()
    logger.info("Lab completed: user=%s lab=%s xp=%d", current_user.id, body.lab_id, lab.xp)

    analytics.track(
        "anonymous",
        AnalyticsEvent.LAB_COMPLETED,
        {
            "lab_id": body.lab_id,
            "xp": lab.xp,
        },
    )

    return ResultResponse(xp_awarded=lab.xp)