# web/backend/app/routers/users.py

import secrets
from fastapi import APIRouter, Depends, HTTPException, status, BackgroundTasks, Request
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, delete
from app.dependencies import get_db, get_current_user, is_user_maintainer, is_user_platform_admin
from app.models import User, LabProgress, SectionProgress, Lab, Section, Module, PlatformRole, PlatformUserRole, Organization, OrganizationMembership
from app.schemas import MeResponse, ProfileUpdateRequest, PasswordUpdateRequest, MessageResponse
from app.auth import verify_password, hash_password
from app.email import send_verification_email

router = APIRouter()


@router.get("/me", response_model=MeResponse)
async def get_me(
    request: Request,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    # 1. Fetch lab progress in a single query, ordered by creation date descending
    lab_progress_list = (await db.execute(
        select(LabProgress).where(
            LabProgress.user_id == current_user.id,
        ).order_by(LabProgress.created_at.desc())
    )).scalars().all()
    completed_labs = [p.lab_id for p in lab_progress_list]

    # 2. Fetch section progress in a single query, ordered by creation date descending
    section_progress_list = (await db.execute(
        select(SectionProgress).where(
            SectionProgress.user_id == current_user.id,
        ).order_by(SectionProgress.created_at.desc())
    )).scalars().all()
    completed_sections = [p.section_id for p in section_progress_list]

    maintainer_status = await is_user_maintainer(current_user, db)
    admin_status = await is_user_platform_admin(current_user, db)

    # Resolve active workspace organization membership to return workspace-scoped XP
    org_slug = request.headers.get("x-organization-slug") or request.headers.get("x-organization")
    org_id_hdr = request.headers.get("x-organization-id")

    mem_stmt = select(OrganizationMembership).join(Organization)
    if org_slug:
        mem_stmt = mem_stmt.where(Organization.slug == org_slug.strip(), OrganizationMembership.user_id == current_user.id)
    elif org_id_hdr:
        try:
            mem_stmt = mem_stmt.where(Organization.id == int(org_id_hdr), OrganizationMembership.user_id == current_user.id)
        except (ValueError, TypeError):
            pass
    else:
        # Default to TLD platform organization membership or first active membership
        mem_stmt = mem_stmt.where(
            OrganizationMembership.user_id == current_user.id,
            OrganizationMembership.status != "removed",
        ).order_by(Organization.is_platform.desc(), OrganizationMembership.created_at.asc())

    active_membership = (await db.execute(mem_stmt)).scalars().first()
    active_xp = int(active_membership.total_xp) if active_membership else 0
    active_unverified_xp = int(active_membership.unverified_xp) if active_membership else 0

    return MeResponse(
        id=current_user.id,
        username=current_user.username,
        email=current_user.email,
        xp=active_xp,
        unverified_xp=active_unverified_xp,
        is_maintainer=maintainer_status,
        is_admin=admin_status,
        completed_labs=completed_labs,
        completed_sections=completed_sections,
    )


@router.put("/me", response_model=MessageResponse)
async def update_profile(
    body: ProfileUpdateRequest,
    background_tasks: BackgroundTasks,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    email_changed = False
    
    if body.username and body.username != current_user.username:
        # Check conflict
        result = await db.execute(select(User).where(User.username == body.username))
        if result.scalar_one_or_none():
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Username is already taken",
            )
        current_user.username = body.username

    if body.email and body.email != current_user.email:
        # Check conflict
        result = await db.execute(select(User).where(User.email == body.email))
        if result.scalar_one_or_none():
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Email is already registered",
            )
        current_user.email = body.email
        current_user.is_verified = False
        verification_token = secrets.token_urlsafe(32)
        current_user.verification_token = verification_token
        email_changed = True

    db.add(current_user)
    await db.commit()

    if email_changed:
        send_verification_email(current_user.email, current_user.verification_token, background_tasks)
        return MessageResponse(
            detail="Profile updated successfully. A verification link has been sent to your new email."
        )

    return MessageResponse(detail="Profile updated successfully.")


@router.put("/me/password", response_model=MessageResponse)
async def update_password(
    body: PasswordUpdateRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    if not verify_password(body.old_password, current_user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid current password.",
        )

    current_user.password_hash = hash_password(body.new_password)
    db.add(current_user)
    await db.commit()

    return MessageResponse(detail="Password updated successfully.")


from pydantic import BaseModel

class MaintainerAddRequest(BaseModel):
    identity: str


@router.get("/admin/maintainers", response_model=list[dict])
async def list_maintainers(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    if not (await is_user_platform_admin(current_user, db)):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only Platform Administrators can manage maintainers",
        )
    result = await db.execute(select(User).where(User.is_maintainer == True).order_by(User.username))
    maintainers = result.scalars().all()
    return [{"id": u.id, "username": u.username, "email": u.email} for u in maintainers]


@router.post("/admin/maintainers", response_model=dict)
async def add_maintainer(
    body: MaintainerAddRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    if not (await is_user_platform_admin(current_user, db)):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only Platform Administrators can manage maintainers",
        )
    
    # Try finding user by username or email
    stmt = select(User).where(
        (User.username == body.identity) | (User.email == body.identity)
    )
    result = await db.execute(stmt)
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
        
    user.is_maintainer = True
    db.add(user)

    # Synchronize platform staff role
    admin_role = (await db.execute(select(PlatformRole).where(PlatformRole.slug == 'platform_admin'))).scalar_one_or_none()
    if admin_role:
        existing_pur = (await db.execute(
            select(PlatformUserRole).where(
                PlatformUserRole.user_id == user.id,
                PlatformUserRole.platform_role_id == admin_role.id
            )
        )).scalar_one_or_none()
        if not existing_pur:
            db.add(PlatformUserRole(user_id=user.id, platform_role_id=admin_role.id, assigned_by=current_user.id))

    await db.commit()
    return {"detail": f"User '{user.username}' is now a maintainer."}


@router.delete("/admin/maintainers/{user_id}", response_model=dict)
async def remove_maintainer(
    user_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    if not (await is_user_platform_admin(current_user, db)):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only Platform Administrators can manage maintainers",
        )
    
    user_res = await db.execute(select(User).where(User.id == user_id))
    user = user_res.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
        
    user.is_maintainer = False
    db.add(user)
    await db.execute(delete(PlatformUserRole).where(PlatformUserRole.user_id == user.id))
    await db.commit()
    return {"detail": f"User '{user.username}' is no longer a maintainer."}

