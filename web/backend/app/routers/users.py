# web/backend/app/routers/users.py

import secrets
from fastapi import APIRouter, Depends, HTTPException, status, BackgroundTasks
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.dependencies import get_db, get_current_user
from app.models import User, LabProgress, SectionProgress
from app.schemas import MeResponse, ProfileUpdateRequest, PasswordUpdateRequest, MessageResponse
from app.auth import verify_password, hash_password
from app.email import send_verification_email

router = APIRouter()


@router.get("/me", response_model=MeResponse)
async def get_me(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    # 1. Fetch lab progress in a single query, ordered by completion date descending
    lab_progress_list = (await db.execute(
        select(LabProgress).where(
            LabProgress.user_id == current_user.id,
            LabProgress.completed == True,
        ).order_by(LabProgress.completed_at.desc())
    )).scalars().all()
    completed_labs = [p.lab_id for p in lab_progress_list]
    lab_xp_sum = sum(p.xp_awarded for p in lab_progress_list)

    # 2. Fetch section progress in a single query, ordered by completion date descending
    section_progress_list = (await db.execute(
        select(SectionProgress).where(
            SectionProgress.user_id == current_user.id,
            SectionProgress.completed == True,
        ).order_by(SectionProgress.completed_at.desc())
    )).scalars().all()
    completed_sections = [p.section_id for p in section_progress_list]
    sec_xp_sum = sum(p.xp_awarded for p in section_progress_list)

    actual_xp = lab_xp_sum + sec_xp_sum

    if current_user.xp != actual_xp:
        current_user.xp = actual_xp
        db.add(current_user)
        await db.commit()

    return MeResponse(
        id=current_user.id,
        username=current_user.username,
        email=current_user.email,
        xp=current_user.xp,
        streak_days=current_user.streak_days,
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

