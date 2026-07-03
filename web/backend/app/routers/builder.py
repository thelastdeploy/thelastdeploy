# web/backend/app/routers/builder.py

import json
import hashlib
from datetime import datetime, timezone
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, delete
from app.dependencies import get_db, get_current_user
from app.models import User, Module, Section, Lab
from app.schemas import (
    BuilderModuleInput,
    BuilderModuleResponse,
    BuilderDraftListItem,
    BuilderModuleDetail,
    BuilderSectionInput,
    BuilderLabInput,
)

router = APIRouter()


def _calculate_validator_hash(script: str | None) -> str | None:
    if not script:
        return None
    normalized = script.encode('utf-8').replace(b"\r\n", b"\n").rstrip()
    return hashlib.sha256(normalized).hexdigest()


# ---------------------------------------------------------------------------
# POST /builder/modules (Create new Module Draft)
# ---------------------------------------------------------------------------
@router.post("/builder/modules", response_model=BuilderModuleResponse, status_code=status.HTTP_201_CREATED)
async def create_module_draft(
    body: BuilderModuleInput,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    # 1. Check if module ID (slug) already exists
    stmt = select(Module).where(Module.id == body.id)
    result = await db.execute(stmt)
    if result.scalar_one_or_none():
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=f"Module ID '{body.id}' is already taken"
        )

    # 2. Insert Module row
    tags_str = ",".join(body.tags)
    new_module = Module(
        id=body.id,
        title=body.title,
        description=body.description,
        topic=body.topic,
        difficulty=body.difficulty,
        estimated_minutes=body.estimated_minutes,
        tags=tags_str,
        yaml_content="", # Drafts don't need yaml_content until verified
        version=1,
        total_xp=0,
        total_sections=0,
        author_id=current_user.id,
        status="draft",
        is_official_verified=False,
        submitted_at=None,
    )
    db.add(new_module)

    # 3. Process Sections and Labs
    total_xp = 0
    total_sections = 0

    for s_input in body.sections:
        total_sections += 1
        total_xp += s_input.xp

        new_section = Section(
            id=s_input.id,
            module_id=body.id,
            title=s_input.title,
            order=s_input.order,
            xp=s_input.xp,
            content=s_input.content,
            version=1,
        )
        db.add(new_section)

        for l_input in s_input.labs:
            total_xp += l_input.xp
            seed_cmds_json = json.dumps(l_input.seed_commands) if l_input.seed_commands else None
            val_hash = _calculate_validator_hash(l_input.validator_script)

            new_lab = Lab(
                id=l_input.id,
                module_id=body.id,
                section_id=s_input.id,
                title=l_input.title,
                order=l_input.order,
                xp=l_input.xp,
                estimated_minutes=l_input.estimated_minutes,
                setup_type=l_input.setup_type,
                seed_commands=seed_cmds_json,
                yaml_content="",
                version=1,
                validator_hash=val_hash,
                validator_script=l_input.validator_script,
            )
            db.add(new_lab)

    new_module.total_xp = total_xp
    new_module.total_sections = total_sections

    await db.commit()
    await db.refresh(new_module)

    return BuilderModuleResponse(
        id=new_module.id,
        title=new_module.title,
        is_official_verified=new_module.is_official_verified,
        total_sections=new_module.total_sections,
        total_xp=new_module.total_xp,
        created_at=new_module.created_at,
    )


# ---------------------------------------------------------------------------
# GET /builder/modules (List my authored modules)
# ---------------------------------------------------------------------------
@router.get("/builder/modules", response_model=list[BuilderDraftListItem])
async def list_my_modules(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    stmt = select(Module).where(Module.author_id == current_user.id).order_by(Module.created_at.desc())
    result = await db.execute(stmt)
    modules = result.scalars().all()

    return [
        BuilderDraftListItem(
            id=m.id,
            title=m.title,
            topic=m.topic,
            difficulty=m.difficulty,
            total_sections=m.total_sections,
            total_xp=m.total_xp,
            status=m.status,
            is_official_verified=m.is_official_verified,
            created_at=m.created_at,
            submitted_at=m.submitted_at,
        )
        for m in modules
    ]


# ---------------------------------------------------------------------------
# GET /builder/modules/{module_id} (Load full module detail for editor)
# ---------------------------------------------------------------------------
@router.get("/builder/modules/{module_id}", response_model=BuilderModuleDetail)
async def get_my_module_detail(
    module_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    stmt = select(Module).where(Module.id == module_id)
    result = await db.execute(stmt)
    module = result.scalar_one_or_none()

    if not module:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")
    if module.author_id != current_user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied")

    # Load sections and labs
    sec_stmt = select(Section).where(Section.module_id == module_id).order_by(Section.order)
    sec_result = await db.execute(sec_stmt)
    sections = sec_result.scalars().all()

    lab_stmt = select(Lab).where(Lab.module_id == module_id).order_by(Lab.order)
    lab_result = await db.execute(lab_stmt)
    all_labs = lab_result.scalars().all()

    labs_by_sec: dict[str, list[Lab]] = {}
    for lab in all_labs:
        labs_by_sec.setdefault(lab.section_id, []).append(lab)

    section_inputs = []
    for s in sections:
        section_labs = labs_by_sec.get(s.id, [])
        lab_inputs = [
            BuilderLabInput(
                id=lab.id,
                title=lab.title,
                order=lab.order,
                xp=lab.xp,
                estimated_minutes=lab.estimated_minutes,
                setup_type=lab.setup_type,
                seed_commands=json.loads(lab.seed_commands) if lab.seed_commands else [],
                validator_script=lab.validator_script,
            )
            for lab in section_labs
        ]
        section_inputs.append(
            BuilderSectionInput(
                id=s.id,
                title=s.title,
                order=s.order,
                xp=s.xp,
                content=s.content,
                labs=lab_inputs,
            )
        )

    tags_list = [t.strip() for t in (module.tags or "").split(",") if t.strip()]

    return BuilderModuleDetail(
        id=module.id,
        title=module.title,
        description=module.description,
        topic=module.topic,
        difficulty=module.difficulty,
        estimated_minutes=module.estimated_minutes,
        tags=tags_list,
        status=module.status,
        sections=section_inputs,
    )


# ---------------------------------------------------------------------------
# PUT /builder/modules/{module_id} (Update Module draft/live content)
# ---------------------------------------------------------------------------
@router.put("/builder/modules/{module_id}", response_model=BuilderModuleResponse)
async def update_module_draft(
    module_id: str,
    body: BuilderModuleInput,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    stmt = select(Module).where(Module.id == module_id)
    result = await db.execute(stmt)
    module = result.scalar_one_or_none()

    if not module:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")
    if module.author_id != current_user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied")

    # Update Module level fields
    tags_str = ",".join(body.tags)
    module.title = body.title
    module.description = body.description
    module.topic = body.topic
    module.difficulty = body.difficulty
    module.estimated_minutes = body.estimated_minutes
    module.tags = tags_str

    # If updating a published or verified module, reset status to published & remove verified badge
    if module.status == "verified":
        module.status = "published"
        module.is_official_verified = False

    # Sync Sections & Labs
    # 1. Fetch current sections/labs in DB
    existing_sec_stmt = select(Section).where(Section.module_id == module_id)
    existing_secs = (await db.execute(existing_sec_stmt)).scalars().all()
    existing_sec_ids = {s.id for s in existing_secs}

    existing_lab_stmt = select(Lab).where(Lab.module_id == module_id)
    existing_labs = (await db.execute(existing_lab_stmt)).scalars().all()
    existing_lab_ids = {l.id for l in existing_labs}

    # 2. Extract new IDs
    new_sec_ids = {s.id for s in body.sections}
    new_lab_ids = {lab.id for s in body.sections for lab in s.labs}

    # 3. Delete deleted sections & labs
    labs_to_delete = existing_lab_ids - new_lab_ids
    if labs_to_delete:
        await db.execute(delete(Lab).where(Lab.id.in_(labs_to_delete)))

    secs_to_delete = existing_sec_ids - new_sec_ids
    if secs_to_delete:
        await db.execute(delete(Section).where(Section.id.in_(secs_to_delete)))

    # 4. Upsert sections & labs
    total_xp = 0
    total_sections = 0

    existing_secs_map = {s.id: s for s in existing_secs}
    existing_labs_map = {l.id: l for l in existing_labs}

    for s_input in body.sections:
        total_sections += 1
        total_xp += s_input.xp

        if s_input.id in existing_secs_map:
            sec = existing_secs_map[s_input.id]
            sec.title = s_input.title
            sec.order = s_input.order
            sec.xp = s_input.xp
            sec.content = s_input.content
            db.add(sec)
        else:
            new_sec = Section(
                id=s_input.id,
                module_id=module_id,
                title=s_input.title,
                order=s_input.order,
                xp=s_input.xp,
                content=s_input.content,
                version=1,
            )
            db.add(new_sec)

        for l_input in s_input.labs:
            total_xp += l_input.xp
            seed_cmds_json = json.dumps(l_input.seed_commands) if l_input.seed_commands else None
            val_hash = _calculate_validator_hash(l_input.validator_script)

            if l_input.id in existing_labs_map:
                lab = existing_labs_map[l_input.id]
                lab.title = l_input.title
                lab.order = l_input.order
                lab.xp = l_input.xp
                lab.estimated_minutes = l_input.estimated_minutes;
                lab.setup_type = l_input.setup_type
                lab.seed_commands = seed_cmds_json
                lab.validator_hash = val_hash
                lab.validator_script = l_input.validator_script
                db.add(lab)
            else:
                new_lab = Lab(
                    id=l_input.id,
                    module_id=module_id,
                    section_id=s_input.id,
                    title=l_input.title,
                    order=l_input.order,
                    xp=l_input.xp,
                    estimated_minutes=l_input.estimated_minutes,
                    setup_type=l_input.setup_type,
                    seed_commands=seed_cmds_json,
                    yaml_content="",
                    version=1,
                    validator_hash=val_hash,
                    validator_script=l_input.validator_script,
                )
                db.add(new_lab)

    module.total_xp = total_xp
    module.total_sections = total_sections
    db.add(module)

    await db.commit()
    await db.refresh(module)

    return BuilderModuleResponse(
        id=module.id,
        title=module.title,
        is_official_verified=module.is_official_verified,
        total_sections=module.total_sections,
        total_xp=module.total_xp,
        created_at=module.created_at,
    )


# ---------------------------------------------------------------------------
# POST /builder/modules/{module_id}/publish (Publish Module draft)
# ---------------------------------------------------------------------------
@router.post("/builder/modules/{module_id}/publish", response_model=BuilderModuleResponse)
async def publish_module_draft(
    module_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    stmt = select(Module).where(Module.id == module_id)
    result = await db.execute(stmt)
    module = result.scalar_one_or_none()

    if not module:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")
    if module.author_id != current_user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied")

    # Fetch sections and labs for validation
    sec_stmt = select(Section).where(Section.module_id == module_id)
    sections = (await db.execute(sec_stmt)).scalars().all()

    lab_stmt = select(Lab).where(Lab.module_id == module_id)
    labs = (await db.execute(lab_stmt)).scalars().all()

    # Validation checks
    errors = []
    if not module.title:
        errors.append("Module title is required.")
    if not sections:
        errors.append("At least one section is required to publish.")
    
    for s in sections:
        if not s.content or not s.content.strip():
            errors.append(f"Section '{s.title}' is missing learning content.")
        
        sec_labs = [l for l in labs if l.section_id == s.id]
        for l in sec_labs:
            if l.xp <= 0:
                errors.append(f"Lab '{l.title}' must reward more than 0 XP.")
            if not l.validator_script or not l.validator_script.strip():
                errors.append(f"Lab '{l.title}' is missing a validator script.")

    if errors:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail=errors
        )

    # Move status to published
    module.status = "published"
    module.submitted_at = datetime.now(timezone.utc)
    db.add(module)

    await db.commit()
    await db.refresh(module)

    return BuilderModuleResponse(
        id=module.id,
        title=module.title,
        is_official_verified=module.is_official_verified,
        total_sections=module.total_sections,
        total_xp=module.total_xp,
        created_at=module.created_at,
    )


# ---------------------------------------------------------------------------
# DELETE /builder/modules/{module_id} (Delete Module draft)
# ---------------------------------------------------------------------------
@router.delete("/builder/modules/{module_id}")
async def delete_module_draft(
    module_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    stmt = select(Module).where(Module.id == module_id)
    result = await db.execute(stmt)
    module = result.scalar_one_or_none()

    if not module:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")
    if module.author_id != current_user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied")

    # Only drafts can be deleted
    if module.status != "draft":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot delete a module once it is published live. You can only edit it."
        )

    # CASCADE delete Sections & Labs manually (or via DB cascade)
    await db.execute(delete(Lab).where(Lab.module_id == module_id))
    await db.execute(delete(Section).where(Section.module_id == module_id))
    await db.execute(delete(Module).where(Module.id == module_id))

    await db.commit()
    return {"detail": f"Draft module '{module_id}' deleted successfully."}
