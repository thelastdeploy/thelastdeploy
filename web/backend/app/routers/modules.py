# web/backend/app/routers/modules.py

from datetime import datetime, timezone
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.dependencies import get_db, get_current_user, get_optional_user
from app.models import Lab, LabProgress, Module, Section, SectionProgress, User
from app.schemas import (
    CompleteSectionResponse,
    LabDetail, LabSchema,
    ModuleListResponse, ModuleListItem,
    ModuleDetail, ModuleSummary,
    SectionSchema,
)

router = APIRouter()

XP_FOR_READING = 10


# ---------------------------------------------------------------------------
# GET /modules
# ---------------------------------------------------------------------------

@router.get("/modules", response_model=ModuleListResponse)
async def list_modules(
    db: AsyncSession = Depends(get_db),
    current_user: User | None = Depends(get_optional_user),
):
    result = await db.execute(select(Module))
    modules = result.scalars().all()

    items = []
    for m in modules:
        sec_result = await db.execute(
            select(Section).where(Section.module_id == m.id).order_by(Section.order)
        )
        sections = sec_result.scalars().all()

        lab_result = await db.execute(select(Lab).where(Lab.module_id == m.id))
        labs = lab_result.scalars().all()
        total_xp = sum(lab.xp for lab in labs) + XP_FOR_READING * sum(
            1 for s in sections if not any(l.section_id == s.id for l in labs)
        )

        completed_sections = 0
        if current_user:
            # Completed lab_ids for this user in this module
            lab_prog_result = await db.execute(
                select(LabProgress.lab_id).where(
                    LabProgress.user_id == current_user.id,
                    LabProgress.module_id == m.id,
                    LabProgress.completed == True,
                )
            )
            completed_lab_ids = {row[0] for row in lab_prog_result.fetchall()}

            # Completed section_ids (reading) for this user
            sec_prog_result = await db.execute(
                select(SectionProgress.section_id).where(
                    SectionProgress.user_id == current_user.id,
                    SectionProgress.module_id == m.id,
                    SectionProgress.completed == True,
                )
            )
            completed_section_ids = {row[0] for row in sec_prog_result.fetchall()}

            for section in sections:
                section_labs = [l for l in labs if l.section_id == section.id]
                if not section_labs:
                    # Reading section — done via section_progress
                    if section.id in completed_section_ids:
                        completed_sections += 1
                else:
                    # Lab section — done when all labs complete
                    if {l.id for l in section_labs}.issubset(completed_lab_ids):
                        completed_sections += 1

        tags = [t.strip() for t in (m.tags or "").split(",") if t.strip()]
        items.append(ModuleListItem(
            id=m.id,
            title=m.title,
            description=m.description,
            topic=m.topic,
            difficulty=m.difficulty,
            estimated_minutes=m.estimated_minutes,
            tags=tags,
            total_xp=total_xp,
            total_sections=len(sections),
            completed_sections=completed_sections,
        ))

    return ModuleListResponse(modules=items)


# ---------------------------------------------------------------------------
# GET /modules/:id/full — sections + labs + progress (frontend)
# ---------------------------------------------------------------------------

@router.get("/modules/{module_id}/full", response_model=ModuleDetail)
async def get_module_full(
    module_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User | None = Depends(get_optional_user),
):
    result = await db.execute(select(Module).where(Module.id == module_id))
    module = result.scalar_one_or_none()
    if not module:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")

    sec_result = await db.execute(
        select(Section).where(Section.module_id == module_id).order_by(Section.order)
    )
    sections = sec_result.scalars().all()

    lab_result = await db.execute(
        select(Lab).where(Lab.module_id == module_id).order_by(Lab.order)
    )
    all_labs = lab_result.scalars().all()
    labs_by_section: dict[str, list[Lab]] = {}
    for lab in all_labs:
        labs_by_section.setdefault(lab.section_id, []).append(lab)

    # Fetch lab progress
    lab_progress_map: dict[str, LabProgress] = {}
    completed_section_ids: set[str] = set()

    if current_user:
        lp_result = await db.execute(
            select(LabProgress).where(
                LabProgress.user_id == current_user.id,
                LabProgress.module_id == module_id,
            )
        )
        for p in lp_result.scalars().all():
            lab_progress_map[p.lab_id] = p

        sp_result = await db.execute(
            select(SectionProgress.section_id).where(
                SectionProgress.user_id == current_user.id,
                SectionProgress.module_id == module_id,
                SectionProgress.completed == True,
            )
        )
        completed_section_ids = {row[0] for row in sp_result.fetchall()}

    section_schemas = []
    for s in sections:
        section_labs = labs_by_section.get(s.id, [])
        lab_schemas = [
            LabSchema(
                id=lab.id,
                title=lab.title,
                order=lab.order,
                xp=lab.xp,
                estimated_minutes=lab.estimated_minutes,
                setup_type=lab.setup_type,
                seed_commands=lab.seed_commands,
                resource_limits_cpu=lab.resource_limits_cpu,
                resource_limits_mem=lab.resource_limits_mem,
                completed=lab_progress_map[lab.id].completed if lab.id in lab_progress_map else False,
                xp_awarded=lab_progress_map[lab.id].xp_awarded if lab.id in lab_progress_map else 0,
            )
            for lab in section_labs
        ]
        section_schemas.append(SectionSchema(
            id=s.id,
            title=s.title,
            order=s.order,
            content=s.content,
            labs=lab_schemas,
            section_completed=s.id in completed_section_ids,
        ))

    tags = [t.strip() for t in (module.tags or "").split(",") if t.strip()]
    total_xp = sum(l.xp for l in all_labs) + XP_FOR_READING * sum(
        1 for s in sections if not labs_by_section.get(s.id)
    )

    return ModuleDetail(
        id=module.id,
        title=module.title,
        description=module.description,
        topic=module.topic,
        difficulty=module.difficulty,
        estimated_minutes=module.estimated_minutes,
        tags=tags,
        total_xp=total_xp,
        total_sections=len(sections),
        sections=section_schemas,
    )


# ---------------------------------------------------------------------------
# GET /modules/:id — lightweight summary (tld sync -m)
# ---------------------------------------------------------------------------

@router.get("/modules/{module_id}", response_model=ModuleSummary)
async def get_module_summary(
    module_id: str,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(Module).where(Module.id == module_id))
    module = result.scalar_one_or_none()
    if not module:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")

    sec_result = await db.execute(select(Section).where(Section.module_id == module_id))
    sections = sec_result.scalars().all()
    lab_result = await db.execute(select(Lab).where(Lab.module_id == module_id))
    labs = lab_result.scalars().all()

    tags = [t.strip() for t in (module.tags or "").split(",") if t.strip()]
    return ModuleSummary(
        id=module.id,
        title=module.title,
        description=module.description,
        topic=module.topic,
        difficulty=module.difficulty,
        estimated_minutes=module.estimated_minutes,
        tags=tags,
        total_xp=sum(l.xp for l in labs),
        total_sections=len(sections),
    )


# ---------------------------------------------------------------------------
# POST /modules/:id/sections/:id/complete — reading sections only
# ---------------------------------------------------------------------------

@router.post(
    "/modules/{module_id}/sections/{section_id}/complete",
    response_model=CompleteSectionResponse,
)
async def complete_reading_section(
    module_id: str,
    section_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Called by frontend when user scrolls to end of a reading section."""
    sec_result = await db.execute(
        select(Section).where(
            Section.id == section_id,
            Section.module_id == module_id,
        )
    )
    section = sec_result.scalar_one_or_none()
    if not section:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Section not found")

    # Only for sections without labs
    lab_check = await db.execute(select(Lab).where(Lab.section_id == section_id))
    if lab_check.scalars().all():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Sections with labs are completed via tld check",
        )

    prog_result = await db.execute(
        select(SectionProgress).where(
            SectionProgress.user_id == current_user.id,
            SectionProgress.section_id == section_id,
        )
    )
    existing = prog_result.scalar_one_or_none()

    if existing and existing.completed:
        return CompleteSectionResponse(xp_awarded=0, total_xp=current_user.xp)

    current_user.xp += XP_FOR_READING
    db.add(current_user)

    if existing:
        existing.completed = True
        existing.xp_awarded = XP_FOR_READING
        existing.completed_at = datetime.now(timezone.utc)
        db.add(existing)
    else:
        db.add(SectionProgress(
            user_id=current_user.id,
            module_id=module_id,
            section_id=section_id,
            completed=True,
            xp_awarded=XP_FOR_READING,
            completed_at=datetime.now(timezone.utc),
        ))

    await db.commit()
    return CompleteSectionResponse(xp_awarded=XP_FOR_READING, total_xp=current_user.xp)


# ---------------------------------------------------------------------------
# GET /labs/:id — for tld sync -l
# ---------------------------------------------------------------------------

@router.get("/labs/{lab_id}", response_model=LabDetail)
async def get_lab(
    lab_id: str,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(Lab).where(Lab.id == lab_id))
    lab = result.scalar_one_or_none()
    if not lab:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Lab not found")

    return LabDetail(
        id=lab.id,
        module_id=lab.module_id,
        section_id=lab.section_id,
        data=LabSchema(
            id=lab.id,
            title=lab.title,
            order=lab.order,
            xp=lab.xp,
            estimated_minutes=lab.estimated_minutes,
            setup_type=lab.setup_type,
            seed_commands=lab.seed_commands,
            resource_limits_cpu=lab.resource_limits_cpu,
            resource_limits_mem=lab.resource_limits_mem,
        ),
    )