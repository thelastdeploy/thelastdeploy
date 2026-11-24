# web/backend/app/routers/modules.py

import asyncio
import os
import json
from fastapi import APIRouter, Depends, HTTPException, status, BackgroundTasks, Request
from fastapi.responses import Response
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.dependencies import (
    get_db,
    get_current_user,
    get_optional_user,
    is_user_maintainer,
    is_user_platform_admin,
    has_platform_permission,
    has_org_permission,
)
from app.models import Lab, LabProgress, Module, Section, SectionProgress, User, Organization, OrganizationMembership
from app.hashing import compute_module_hash, compute_section_hash, compute_lab_hash
from app.schemas import (
    AuthorInfo,
    CompleteSectionResponse,
    LabDetail, LabSchema,
    ModuleListResponse, ModuleListItem,
    ModuleDetail, ModuleSummary,
    SectionSchema,
    VerifyModulePayload, VerifySectionXP, VerifyLabXP, RejectModulePayload,
    ModuleExportResponse, SectionExportItem, LabExportItem,
)
from app.services import (
    recalculate_and_update_user_xp,
    check_and_track_module_completion,
    get_or_create_platform_membership,
    get_organizations_using_content,
    recalculate_membership_xp,
)
from app.analytics import analytics, AnalyticsEvent

router = APIRouter()


OFFICIAL_AUTHOR = AuthorInfo(name="The Last Deploy", is_official=True)


def _author_info(author: "User | None") -> AuthorInfo:
    """Return an AuthorInfo from a resolved author ORM object (or None for official)."""
    if author is None:
        return OFFICIAL_AUTHOR
    return AuthorInfo(name=author.username, is_official=False)


def _total_xp(sections: list[Section], labs: list[Lab]) -> int:
    """Total XP = sum of all section.xp (reading) + sum of all lab.xp."""
    return sum(s.xp for s in sections) + sum(l.xp for l in labs)


async def _get_visible_org_ids(request: Request, db: AsyncSession, current_user: User | None) -> list[int]:
    """
    Returns the organization IDs whose content is visible in the current request.
    In a tenant workspace, returns ONLY that organization ID (no platform leakage).
    In the platform workspace (no tenant header), returns the platform organization ID.
    """
    org_slug = request.headers.get("x-organization-slug") or request.headers.get("x-organization")
    org_id_hdr = request.headers.get("x-organization-id")

    platform_org_id = await db.scalar(
        select(Organization.id).where(Organization.type == "platform")
    )

    target_org_id = None
    if org_slug:
        matched_id = await db.scalar(select(Organization.id).where(Organization.slug == org_slug.strip()))
        if matched_id:
            target_org_id = matched_id
    elif org_id_hdr:
        try:
            target_id = int(org_id_hdr)
            exists = await db.scalar(select(Organization.id).where(Organization.id == target_id))
            if exists:
                target_org_id = target_id
        except (ValueError, TypeError):
            pass
    elif current_user:
        primary_membership = (await db.execute(
            select(OrganizationMembership.organization_id)
            .join(Organization, Organization.id == OrganizationMembership.organization_id)
            .where(
                OrganizationMembership.user_id == current_user.id,
                OrganizationMembership.status == "active",
                Organization.type != "platform",
            )
            .order_by(OrganizationMembership.created_at.asc())
        )).scalars().first()
        if primary_membership:
            target_org_id = primary_membership

    if target_org_id:
        return [target_org_id]

    return [platform_org_id] if platform_org_id else []


# ---------------------------------------------------------------------------
# GET /modules
# ---------------------------------------------------------------------------

@router.get("/modules", response_model=ModuleListResponse)
async def list_modules(
    request: Request,
    response: Response,
    db: AsyncSession = Depends(get_db),
    current_user: User | None = Depends(get_optional_user),
):
    # Cache-Control: public list is stable; authenticated responses are user-specific
    if current_user:
        response.headers["Cache-Control"] = "private, max-age=0, must-revalidate"
    else:
        response.headers["Cache-Control"] = "public, max-age=30, stale-while-revalidate=120"

    visible_org_ids = await _get_visible_org_ids(request, db, current_user)

    # 1. Retrieve completed section IDs for the current user
    completed_section_ids: set[str] = set()
    if current_user:
        user_mems = (await db.scalars(
            select(OrganizationMembership.id).where(
                OrganizationMembership.user_id == current_user.id,
                OrganizationMembership.status != "removed",
            )
        )).all()
        if user_mems:
            sp_result = await db.scalars(
                select(SectionProgress.section_id).where(
                    SectionProgress.organization_membership_id.in_(user_mems)
                )
            )
            completed_section_ids = set(sp_result.all())

    # 2. Query Module table columns
    stmt = select(
        Module.id,
        Module.title,
        Module.description,
        Module.topic,
        Module.difficulty,
        Module.estimated_minutes,
        Module.total_xp,
        Module.sections,
        Module.version,
        Module.author_id,
        Module.status,
    ).where(
        Module.status != 'draft',
        Module.owner_organization_id.in_(visible_org_ids),
    )
    result = await db.execute(stmt)
    rows = result.all()

    # 3. Collect author_ids that are non-null and batch-load those users
    author_ids = {row.author_id for row in rows if row.author_id is not None}
    author_map: dict[int, User] = {}
    if author_ids:
        au_result = await db.execute(select(User).where(User.id.in_(author_ids)))
        author_map = {u.id: u for u in au_result.scalars().all()}

    # 4. Build ModuleListItem list
    items = []
    for row in rows:
        author = author_map.get(row.author_id) if row.author_id else None
        sections_list = row.sections or []
        completed_count = len([sid for sid in sections_list if sid in completed_section_ids])
        items.append(ModuleListItem(
            id=row.id,
            title=row.title,
            description=row.description,
            topic=row.topic,
            difficulty=row.difficulty,
            estimated_minutes=row.estimated_minutes,
            total_xp=row.total_xp,
            total_sections=len(sections_list),
            completed_sections=completed_count,
            version=row.version,
            author=_author_info(author),
            status=row.status,
            is_official_verified=(row.status == "verified"),
        ))

    return ModuleListResponse(modules=items)



# ---------------------------------------------------------------------------
# GET /modules/all/full — bulk details (sections + labs + progress)
# ---------------------------------------------------------------------------

@router.get("/modules/all/full", response_model=list[ModuleDetail])
async def get_all_modules_full(
    request: Request,
    response: Response,
    exclude_content: bool = True,
    db: AsyncSession = Depends(get_db),
    current_user: User | None = Depends(get_optional_user),
):
    if current_user:
        response.headers["Cache-Control"] = "private, max-age=0, must-revalidate"
    else:
        response.headers["Cache-Control"] = "public, max-age=30, stale-while-revalidate=120"

    from sqlalchemy.orm import selectinload

    visible_org_ids = await _get_visible_org_ids(request, db, current_user)

    # 1. Eagerly load all visible modules
    result = await db.execute(
        select(Module)
        .where(
            Module.status != 'draft',
            Module.owner_organization_id.in_(visible_org_ids),
        )
        .options(
            selectinload(Module.author),
        )
    )
    modules = result.scalars().all()

    platform_org_id = await db.scalar(select(Organization.id).where(Organization.type == "platform"))
    allowed_content_orgs = set(visible_org_ids)
    if platform_org_id:
        allowed_content_orgs.add(platform_org_id)

    # 2. Batch load all referenced sections and labs (scoped to allowed orgs)
    all_sec_ids = [sid for m in modules for sid in (m.sections or [])]
    sec_map: dict[str, Section] = {}
    if all_sec_ids:
        sec_rows = (await db.execute(
            select(Section)
            .where(Section.id.in_(all_sec_ids), Section.owner_organization_id.in_(allowed_content_orgs))
        )).scalars().all()
        # Prefer org-owned section over platform section if same ID exists
        sec_map = {s.id: s for s in sorted(sec_rows, key=lambda s: 1 if s.owner_organization_id == platform_org_id else 2)}

    all_lab_ids = [lid for s in sec_map.values() for lid in (s.labs or [])]
    lab_map: dict[str, Lab] = {}
    if all_lab_ids:
        lab_rows = (await db.execute(
            select(Lab)
            .where(Lab.id.in_(all_lab_ids), Lab.owner_organization_id.in_(allowed_content_orgs))
        )).scalars().all()
        # Prefer org-owned lab over platform lab if same ID exists
        lab_map = {l.id: l for l in sorted(lab_rows, key=lambda l: 1 if l.owner_organization_id == platform_org_id else 2)}

    # 3. Retrieve user's lab and section progress globally
    lab_progress_map = {}
    completed_section_ids = set()

    if current_user:
        # Get all memberships for the current user
        user_mems = (await db.scalars(
            select(OrganizationMembership.id).where(
                OrganizationMembership.user_id == current_user.id,
                OrganizationMembership.status != "removed",
            )
        )).all()

        if user_mems:
            lp_result = await db.execute(
                select(LabProgress).where(LabProgress.organization_membership_id.in_(user_mems))
            )
            for p in lp_result.scalars().all():
                lab_progress_map[p.lab_id] = p

            sp_result = await db.execute(
                select(SectionProgress.section_id).where(
                    SectionProgress.organization_membership_id.in_(user_mems)
                )
            )
            completed_section_ids = {row[0] for row in sp_result.fetchall()}

    # 4. Build ModuleDetail list
    items = []
    for m in modules:
        sec_ids = m.sections or []
        sections_for_mod = [sec_map[sid] for sid in sec_ids if sid in sec_map]
        section_schemas = []
        for s_idx, s in enumerate(sections_for_mod):
            lab_ids = s.labs or []
            labs_for_sec = [lab_map[lid] for lid in lab_ids if lid in lab_map]
            lab_schemas = [
                LabSchema(
                    id=lab.id,
                    title=lab.title,
                    order=l_idx + 1,
                    xp=lab.xp,
                    estimated_minutes=lab.estimated_minutes,
                    environment_profile=lab.environment_profile,
                    seed_commands=lab.seed_commands,
                    completed=lab.id in lab_progress_map,
                    xp_awarded=lab_progress_map[lab.id].xp_awarded if lab.id in lab_progress_map else 0,
                    version=lab.version,
                )
                for l_idx, lab in enumerate(labs_for_sec)
            ]
            section_schemas.append(SectionSchema(
                id=s.id,
                title=s.title,
                order=s_idx + 1,
                xp=s.xp,
                content=None if exclude_content else s.content,
                labs=lab_schemas,
                section_completed=s.id in completed_section_ids,
                version=s.version,
            ))

        all_labs = [lab_map[lid] for s in sections_for_mod for lid in (s.labs or []) if lid in lab_map]
        items.append(ModuleDetail(
            id=m.id,
            title=m.title,
            description=m.description,
            topic=m.topic,
            difficulty=m.difficulty,
            estimated_minutes=m.estimated_minutes,
            shared_seed=m.shared_seed or [],
            total_xp=_total_xp(sections_for_mod, all_labs),
            total_sections=len(sec_ids),
            sections=section_schemas,
            version=m.version,
            author=_author_info(m.author),
            status=m.status,
            is_official_verified=(m.status == "verified"),
        ))

    return items


# ---------------------------------------------------------------------------
# GET /modules/:id/full — sections + labs + progress (frontend)
# ---------------------------------------------------------------------------

@router.get("/modules/{module_id}/full", response_model=ModuleDetail)
async def get_module_full(
    request: Request,
    module_id: str,
    background_tasks: BackgroundTasks,
    db: AsyncSession = Depends(get_db),
    current_user: User | None = Depends(get_optional_user),
):
    from sqlalchemy.orm import selectinload

    visible_org_ids = await _get_visible_org_ids(request, db, current_user)
    platform_org_id = await db.scalar(select(Organization.id).where(Organization.type == "platform"))
    allowed_content_orgs = set(visible_org_ids)
    if platform_org_id:
        allowed_content_orgs.add(platform_org_id)

    result = await db.execute(
        select(Module)
        .options(selectinload(Module.author))
        .where(
            Module.id == module_id,
            Module.owner_organization_id.in_(visible_org_ids),
        )
    )
    module = result.scalar_one_or_none()
    if not module:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")

    sec_ids = module.sections or []
    sec_map: dict[str, Section] = {}
    sections: list[Section] = []
    if sec_ids:
        sec_rows = (await db.execute(
            select(Section)
            .where(Section.id.in_(sec_ids), Section.owner_organization_id.in_(allowed_content_orgs))
        )).scalars().all()
        sec_map = {s.id: s for s in sorted(sec_rows, key=lambda s: 1 if s.owner_organization_id == platform_org_id else 2)}
        sections = [sec_map[sid] for sid in sec_ids if sid in sec_map]

    all_lab_ids = [lid for s in sections for lid in (s.labs or [])]
    lab_map: dict[str, Lab] = {}
    if all_lab_ids:
        lab_rows = (await db.execute(
            select(Lab)
            .where(Lab.id.in_(all_lab_ids), Lab.owner_organization_id.in_(allowed_content_orgs))
        )).scalars().all()
        lab_map = {l.id: l for l in sorted(lab_rows, key=lambda l: 1 if l.owner_organization_id == platform_org_id else 2)}

    lab_progress_map: dict[str, LabProgress] = {}
    completed_section_ids: set[str] = set()

    if current_user:
        # Get all memberships for the current user
        user_mems = (await db.scalars(
            select(OrganizationMembership.id).where(
                OrganizationMembership.user_id == current_user.id,
                OrganizationMembership.status != "removed",
            )
        )).all()

        if user_mems:
            lp_stmt = select(LabProgress).where(
                LabProgress.organization_membership_id.in_(user_mems),
                LabProgress.lab_id.in_(all_lab_ids) if all_lab_ids else True,
            )
            sp_stmt = select(SectionProgress.section_id).where(
                SectionProgress.organization_membership_id.in_(user_mems),
                SectionProgress.section_id.in_(sec_ids) if sec_ids else True,
            )
            lp_result, sp_result = await asyncio.gather(
                db.execute(lp_stmt),
                db.execute(sp_stmt),
            )
            for p in lp_result.scalars().all():
                lab_progress_map[p.lab_id] = p
            completed_section_ids = {row[0] for row in sp_result.fetchall()}

    section_schemas = []
    for s_idx, s in enumerate(sections):
        lab_ids = s.labs or []
        section_labs = [lab_map[lid] for lid in lab_ids if lid in lab_map]
        lab_schemas = [
            LabSchema(
                id=lab.id,
                title=lab.title,
                order=l_idx + 1,
                xp=lab.xp,
                estimated_minutes=lab.estimated_minutes,
                environment_profile=lab.environment_profile,
                seed_commands=lab.seed_commands,
                completed=lab.id in lab_progress_map,
                xp_awarded=lab_progress_map[lab.id].xp_awarded if lab.id in lab_progress_map else 0,
                version=lab.version,
            )
            for l_idx, lab in enumerate(section_labs)
        ]
        section_schemas.append(SectionSchema(
            id=s.id,
            title=s.title,
            order=s_idx + 1,
            xp=s.xp,
            content=s.content,
            labs=lab_schemas,
            section_completed=s.id in completed_section_ids,
            version=s.version,
        ))

    all_labs = [lab_map[lid] for s in sections for lid in (s.labs or []) if lid in lab_map]

    # Fire analytics in background — never blocks the response
    background_tasks.add_task(
        analytics.track,
        "anonymous",
        AnalyticsEvent.MODULE_STARTED,
        {
            "module_id": module.id,
            "title": module.title,
            "topic": module.topic,
            "difficulty": module.difficulty,
            "estimated_minutes": module.estimated_minutes,
        },
    )

    return ModuleDetail(
        id=module.id,
        title=module.title,
        description=module.description,
        topic=module.topic,
        difficulty=module.difficulty,
        estimated_minutes=module.estimated_minutes,
        shared_seed=module.shared_seed or [],
        total_xp=0 if module.status != "verified" else _total_xp(sections, all_labs),
        total_sections=len(sections),
        sections=section_schemas,
        version=module.version,
        author=_author_info(module.author),
        status=module.status,
        is_official_verified=(module.status == "verified"),
    )


# ---------------------------------------------------------------------------
# GET /modules/:id — lightweight summary (tld sync -m)
# ---------------------------------------------------------------------------

@router.get("/modules/{module_id}", response_model=ModuleSummary)
async def get_module_summary(
    request: Request,
    module_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User | None = Depends(get_optional_user),
):
    from sqlalchemy.orm import selectinload
    visible_org_ids = await _get_visible_org_ids(request, db, current_user)
    platform_org_id = await db.scalar(select(Organization.id).where(Organization.type == "platform"))
    allowed_content_orgs = set(visible_org_ids)
    if platform_org_id:
        allowed_content_orgs.add(platform_org_id)

    result = await db.execute(
        select(Module)
        .options(selectinload(Module.author))
        .where(
            Module.id == module_id,
            Module.owner_organization_id.in_(visible_org_ids),
        )
    )
    module = result.scalar_one_or_none()
    if not module:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")

    sec_ids = module.sections or []
    sections: list[Section] = []
    if sec_ids:
        sec_rows = (await db.execute(
            select(Section)
            .where(Section.id.in_(sec_ids), Section.owner_organization_id.in_(allowed_content_orgs))
        )).scalars().all()
        sec_map = {s.id: s for s in sorted(sec_rows, key=lambda s: 1 if s.owner_organization_id == platform_org_id else 2)}
        sections = [sec_map[sid] for sid in sec_ids if sid in sec_map]

    all_lab_ids = [lid for s in sections for lid in (s.labs or [])]
    labs: list[Lab] = []
    if all_lab_ids:
        lab_rows = (await db.execute(
            select(Lab)
            .where(Lab.id.in_(all_lab_ids), Lab.owner_organization_id.in_(allowed_content_orgs))
        )).scalars().all()
        lab_map = {l.id: l for l in sorted(lab_rows, key=lambda l: 1 if l.owner_organization_id == platform_org_id else 2)}
        labs = [lab_map[lid] for lid in all_lab_ids if lid in lab_map]

    return ModuleSummary(
        id=module.id,
        title=module.title,
        description=module.description,
        topic=module.topic,
        difficulty=module.difficulty,
        estimated_minutes=module.estimated_minutes,
        shared_seed=module.shared_seed or [],
        total_xp=0 if module.status != "verified" else _total_xp(sections, labs),
        total_sections=len(sections),
        version=module.version,
        author=_author_info(module.author),
        status=module.status,
        is_official_verified=(module.status == "verified"),
    )


# ---------------------------------------------------------------------------
# GET /modules/:id/export — export official verified module for contributor pull
# ---------------------------------------------------------------------------

@router.get("/modules/{module_id}/export", response_model=ModuleExportResponse)
async def export_module_for_pull(
    module_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """
    Export a public, verified TLD official curriculum module for local customization (tld pull).
    Enforces that only public verified modules owned by the TLD platform organization can be pulled.
    """
    platform_org = await db.scalar(
        select(Organization).where((Organization.type == "platform") | (Organization.slug == "tld"))
    )
    if not platform_org:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Platform organization not configured.")

    stmt = select(Module).where(Module.id == module_id)
    module = (await db.execute(stmt)).scalar_one_or_none()
    if not module:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Module '{module_id}' not found.")

    # Restrict: must be owned by TLD platform organization
    if module.owner_organization_id != platform_org.id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Only official verified TLD curriculum modules can be pulled for customization.",
        )

    # Restrict: must be verified
    if module.status != "verified":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Only official verified TLD curriculum modules can be pulled for customization.",
        )

    # Resolve sections and labs
    sec_ids = module.sections or []
    sec_map: dict[str, Section] = {}
    sections: list[Section] = []
    if sec_ids:
        sec_rows = (await db.execute(select(Section).where(Section.id.in_(sec_ids)))).scalars().all()
        sec_map = {s.id: s for s in sec_rows}
        sections = [sec_map[sid] for sid in sec_ids if sid in sec_map]

    all_lab_ids = [lid for s in sections for lid in (s.labs or [])]
    lab_map: dict[str, Lab] = {}
    if all_lab_ids:
        lab_rows = (await db.execute(select(Lab).where(Lab.id.in_(all_lab_ids)))).scalars().all()
        lab_map = {l.id: l for l in lab_rows}

    # If challenges exist on disk, read raw files to ensure 100% preservation of comments/formatting
    challenges_dir = os.getenv("CHALLENGES_DIR", "/app/challenges")
    mod_disk_path = os.path.join(challenges_dir, module.id)

    raw_mod_yaml = None
    if os.path.isdir(mod_disk_path):
        m_yaml_path = os.path.join(mod_disk_path, "module.yaml")
        if os.path.exists(m_yaml_path):
            with open(m_yaml_path, "r", encoding="utf-8") as f:
                raw_mod_yaml = f.read()

    if not raw_mod_yaml:
        raw_mod_yaml = f"""id: {module.id}
title: "{module.title}"
description: "{module.description or ''}"
topic: {module.topic or 'general'}
difficulty: {module.difficulty or 'beginner'}
estimated_minutes: {module.estimated_minutes or 30}
"""

    mod_hash = compute_module_hash(raw_mod_yaml)

    section_exports = []
    for s_idx, s in enumerate(sections):
        sec_disk_path = os.path.join(mod_disk_path, "sections", s.id)
        raw_sec_yaml = None
        content_md = s.content

        if os.path.isdir(sec_disk_path):
            s_yaml_path = os.path.join(sec_disk_path, "section.yaml")
            if os.path.exists(s_yaml_path):
                with open(s_yaml_path, "r", encoding="utf-8") as f:
                    raw_sec_yaml = f.read()
            c_md_path = os.path.join(sec_disk_path, "content.md")
            if os.path.exists(c_md_path):
                with open(c_md_path, "r", encoding="utf-8") as f:
                    content_md = f.read()

        if not raw_sec_yaml:
            raw_sec_yaml = f"""id: {s.id}
title: "{s.title}"
order: {s_idx + 1}
xp: {s.xp}
"""
        sec_hash = compute_section_hash(raw_sec_yaml, content_md)

        lab_ids = s.labs or []
        lab_exports = []
        for l_idx, lid in enumerate(lab_ids):
            lab = lab_map.get(lid)
            if not lab:
                continue

            lab_disk_path = os.path.join(sec_disk_path, "labs", lab.id)
            raw_lab_yaml = None
            cleanup_sh = None
            val_script = lab.validator_script
            is_py_val = False

            if os.path.isdir(lab_disk_path):
                l_yaml_path = os.path.join(lab_disk_path, "lab.yaml")
                if os.path.exists(l_yaml_path):
                    with open(l_yaml_path, "r", encoding="utf-8") as f:
                        raw_lab_yaml = f.read()
                clean_path = os.path.join(lab_disk_path, "cleanup.sh")
                if os.path.exists(clean_path):
                    with open(clean_path, "r", encoding="utf-8") as f:
                        cleanup_sh = f.read()
                val_path = os.path.join(lab_disk_path, "validator.sh")
                if os.path.exists(val_path):
                    with open(val_path, "r", encoding="utf-8") as f:
                        val_script = f.read()
                else:
                    val_py_path = os.path.join(lab_disk_path, "validator.py")
                    if os.path.exists(val_py_path):
                        with open(val_py_path, "r", encoding="utf-8") as f:
                            val_script = f.read()
                            is_py_val = True

            if not raw_lab_yaml:
                seed_list_str = ""
                if lab.seed_commands:
                    try:
                        cmds = json.loads(lab.seed_commands) if isinstance(lab.seed_commands, str) else lab.seed_commands
                        if cmds:
                            seed_list_str = "\nseed_commands:\n" + "\n".join(f'  - "{c}"' for c in cmds)
                    except Exception:
                        pass
                raw_lab_yaml = f"""id: {lab.id}
title: "{lab.title}"
order: {l_idx + 1}
xp: {lab.xp}
estimated_minutes: {lab.estimated_minutes or 10}
environment:
  profile: {lab.environment_profile}{seed_list_str}
"""
            lab_hash = compute_lab_hash(
                raw_lab_yaml,
                cleanup_sh,
                val_script if not is_py_val else None,
                val_script if is_py_val else None,
            )

            seed_cmds = []
            if lab.seed_commands:
                try:
                    seed_cmds = json.loads(lab.seed_commands) if isinstance(lab.seed_commands, str) and lab.seed_commands.startswith("[") else []
                except Exception:
                    pass

            lab_exports.append(LabExportItem(
                id=lab.id,
                title=lab.title,
                order=l_idx + 1,
                estimated_minutes=lab.estimated_minutes,
                environment_profile=lab.environment_profile,
                seed_commands=seed_cmds,
                validator_script=val_script,
                cleanup_script=cleanup_sh,
                raw_lab_yaml=raw_lab_yaml,
                is_python_validator=is_py_val,
                content_hash=lab_hash,
            ))

        section_exports.append(SectionExportItem(
            id=s.id,
            title=s.title,
            order=s_idx + 1,
            content=content_md,
            raw_section_yaml=raw_sec_yaml,
            content_hash=sec_hash,
            labs=lab_exports,
        ))

    return ModuleExportResponse(
        id=module.id,
        title=module.title,
        description=module.description,
        topic=module.topic,
        difficulty=module.difficulty,
        estimated_minutes=module.estimated_minutes,
        raw_module_yaml=raw_mod_yaml,
        content_hash=mod_hash,
        owner_organization_id=module.owner_organization_id,
        is_official_verified=True,
        sections=section_exports,
    )


@router.patch("/modules/{module_id}/verify", response_model=dict)
@router.post("/modules/{module_id}/verify", response_model=dict)
async def verify_module(
    module_id: str,
    background_tasks: BackgroundTasks,
    payload: VerifyModulePayload | None = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(select(Module).where(Module.id == module_id))
    module = result.scalar_one_or_none()
    if not module:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")

    is_platform_admin = await is_user_platform_admin(current_user, db) or await has_platform_permission(current_user, "platform.modules.verify", db)
    if not is_platform_admin:
        mem = await db.scalar(
            select(OrganizationMembership).where(
                OrganizationMembership.organization_id == module.owner_organization_id,
                OrganizationMembership.user_id == current_user.id,
                OrganizationMembership.status == "active",
            )
        )
        if not mem or not await has_org_permission(mem, "content.verify", current_user, db):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Missing required permission: 'content.verify' to verify this module",
            )

    # 1. Update XP in sections and labs + progress rows
    from sqlalchemy import update

    total_xp = 0
    if payload and payload.sections:
        for s_input in payload.sections:
            total_xp += s_input.xp
            # Update section XP
            await db.execute(
                update(Section)
                .where(Section.id == s_input.id)
                .values(xp=s_input.xp)
            )
            # Update section progress awarded XP
            await db.execute(
                update(SectionProgress)
                .where(SectionProgress.section_id == s_input.id)
                .values(xp_awarded=s_input.xp)
            )

            for l_input in s_input.labs:
                total_xp += l_input.xp
                # Update lab XP
                await db.execute(
                    update(Lab)
                    .where(Lab.id == l_input.id)
                    .values(xp=l_input.xp)
                )
                # Update lab progress awarded XP
                await db.execute(
                    update(LabProgress)
                    .where(LabProgress.lab_id == l_input.id)
                    .values(xp_awarded=l_input.xp)
                )
    else:
        # Calculate from existing sections & labs
        sec_ids = module.sections or []
        sections_found: list[Section] = []
        if sec_ids:
            sec_rows = (await db.execute(select(Section).where(Section.id.in_(sec_ids)))).scalars().all()
            sec_map = {s.id: s for s in sec_rows}
            sections_found = [sec_map[sid] for sid in sec_ids if sid in sec_map]

        all_lab_ids = [lid for s in sections_found for lid in (s.labs or [])]
        labs_found: list[Lab] = []
        if all_lab_ids:
            labs_found = (await db.execute(select(Lab).where(Lab.id.in_(all_lab_ids)))).scalars().all()
        total_xp = _total_xp(sections_found, labs_found)

    module.total_xp = total_xp
    module.status = "verified"
    db.add(module)
    await db.flush()

    # Move unverified XP to verified XP for all users who completed sections/labs in this module
    sec_ids = module.sections or []
    sections: list[Section] = []
    if sec_ids:
        sec_rows = (await db.execute(select(Section).where(Section.id.in_(sec_ids)))).scalars().all()
        sec_map = {s.id: s for s in sec_rows}
        sections = [sec_map[sid] for sid in sec_ids if sid in sec_map]

    all_lab_ids = [lid for s in sections for lid in (s.labs or [])]
    labs: list[Lab] = []
    if all_lab_ids:
        labs = (await db.execute(select(Lab).where(Lab.id.in_(all_lab_ids)))).scalars().all()
    lab_map = {l.id: l for l in labs}

    affected_mem_ids: set[int] = set()
    if all_lab_ids:
        l_mems = (await db.scalars(
            select(LabProgress.organization_membership_id).where(LabProgress.lab_id.in_(all_lab_ids))
        )).all()
        affected_mem_ids.update(l_mems)

    if sec_ids:
        s_mems = (await db.scalars(
            select(SectionProgress.organization_membership_id).where(SectionProgress.section_id.in_(sec_ids))
        )).all()
        affected_mem_ids.update(s_mems)

    for mid in affected_mem_ids:
        await recalculate_membership_xp(mid, db)

    await db.commit()

    # 2. Serialize and push the newly assigned XP grading and verified files to GitHub
    from app.routers.builder import push_to_github_task, build_github_challenge_files

    sections_data = [
        {
            "id": sec.id,
            "title": sec.title,
            "order": s_idx + 1,
            "xp": sec.xp,
            "content": sec.content,
            "labs": [
                {
                    "id": lab.id,
                    "title": lab.title,
                    "xp": lab.xp,
                    "estimated_minutes": lab.estimated_minutes,
                    "seed_commands": lab.seed_commands,
                    "validator_script": lab.validator_script,
                    "version": lab.version or 1,
                }
                for lab in [lab_map[lid] for lid in (sec.labs or []) if lid in lab_map]
            ],
        }
        for s_idx, sec in enumerate(sections)
    ]
    github_files = build_github_challenge_files(
        module_id=module.id,
        title=module.title,
        description=module.description,
        topic=module.topic,
        difficulty=module.difficulty,
        estimated_minutes=module.estimated_minutes,
        tags=[],
        sections=sections_data,
        is_verified=True,
        version=module.version or 1,
    )

    # Enqueue GitHub commit as a background task
    background_tasks.add_task(
        push_to_github_task,
        module_id,
        github_files,
        f"chore(challenge): verify and update XP grading for {module_id}"
    )

    return {"detail": f"Module '{module_id}' is now officially verified."}


@router.patch("/modules/{module_id}/reject", response_model=dict)
async def reject_module(
    module_id: str,
    payload: RejectModulePayload,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(select(Module).where(Module.id == module_id))
    module = result.scalar_one_or_none()
    if not module:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")

    is_platform_admin = await is_user_platform_admin(current_user, db) or await has_platform_permission(current_user, "platform.modules.verify", db)
    if not is_platform_admin:
        mem = await db.scalar(
            select(OrganizationMembership).where(
                OrganizationMembership.organization_id == module.owner_organization_id,
                OrganizationMembership.user_id == current_user.id,
                OrganizationMembership.status == "active",
            )
        )
        if not mem or not await has_org_permission(mem, "content.verify", current_user, db):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Missing required permission: 'content.verify' to reject this module submission",
            )

    if module.status == "verified":
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Cannot reject an already verified module.")

    module.status = "draft"
    db.add(module)
    await db.commit()

    from app.services import log_audit_event
    await log_audit_event(
        db,
        action="module.rejected",
        entity_type="module",
        entity_id=module.id,
        actor_user_id=current_user.id,
        organization_id=module.owner_organization_id,
        metadata={"id": module.id, "reason": payload.reason},
    )

    return {"detail": f"Module '{module.title}' submission rejected."}


# ---------------------------------------------------------------------------
# POST /modules/:id/sections/:id/complete — reading sections
# ---------------------------------------------------------------------------

@router.post(
    "/modules/{module_id}/sections/{section_id}/complete",
    response_model=CompleteSectionResponse,
)
@router.post(
    "/sections/{section_id}/complete",
    response_model=CompleteSectionResponse,
)
async def complete_reading_section(
    section_id: str,
    module_id: str | None = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    if module_id:
        result = await db.execute(select(Module).where(Module.id == module_id))
        module = result.scalar_one_or_none()
        if not module:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")

    sec_result = await db.execute(select(Section).where(Section.id == section_id))
    section = sec_result.scalar_one_or_none()
    if not section:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Section not found")

    # Get all active memberships for user
    user_mems = (await db.scalars(
        select(OrganizationMembership).where(
            OrganizationMembership.user_id == current_user.id,
            OrganizationMembership.status != "removed",
        )
    )).all()
    if not user_mems:
        default_mem = await get_or_create_platform_membership(current_user.id, db)
        await db.flush()
        user_mems = [default_mem]

    mem_ids = [m.id for m in user_mems]

    # For lab sections — verify all required labs are completed before allowing section completion
    lab_ids = section.labs or []
    if lab_ids:
        completed_labs = await db.execute(
            select(LabProgress.lab_id).where(
                LabProgress.organization_membership_id.in_(mem_ids),
                LabProgress.lab_id.in_(lab_ids),
            )
        )
        completed_lab_ids = {row[0] for row in completed_labs.fetchall()}
        if not set(lab_ids).issubset(completed_lab_ids):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Cannot complete section: all required labs in this section must be completed first",
            )

    # Determine which organizations use this section entity
    using_org_ids = await get_organizations_using_content(db, section_id=section_id)
    if not using_org_ids:
        using_org_ids.add(section.owner_organization_id)

    # Filter user's memberships to only those in organizations using this section
    eligible_memberships = [m for m in user_mems if m.organization_id in using_org_ids]
    if not eligible_memberships:
        plat_org = await db.scalar(
            select(Organization).where((Organization.type == "platform") | (Organization.slug == "tld"))
        )
        if plat_org and plat_org.id in using_org_ids:
            default_mem = await get_or_create_platform_membership(current_user.id, db)
            await db.flush()
            eligible_memberships = [default_mem]

    any_new_completion = False
    xp = section.xp

    for m in eligible_memberships:
        existing = await db.scalar(
            select(SectionProgress.id).where(
                SectionProgress.organization_membership_id == m.id,
                SectionProgress.section_id == section_id,
            )
        )
        if not existing:
            db.add(SectionProgress(
                organization_membership_id=m.id,
                section_id=section_id,
                xp_awarded=xp,
            ))
            any_new_completion = True

    await db.flush()

    # Recalculate verified and unverified XP for all eligible memberships
    for m in eligible_memberships:
        await recalculate_membership_xp(m.id, db)

    await db.commit()

    if module_id:
        analytics.track(
            "anonymous",
            AnalyticsEvent.SECTION_COMPLETED,
            {
                "module_id": module_id,
                "section_id": section_id,
                "xp": xp,
            },
        )
        await check_and_track_module_completion(current_user.id, module_id, db)

    reported_total_xp = eligible_memberships[0].total_xp if eligible_memberships else 0
    return CompleteSectionResponse(xp_awarded=xp if any_new_completion else 0, total_xp=reported_total_xp)


# ---------------------------------------------------------------------------
# GET /labs/:id — for tld sync -l
# ---------------------------------------------------------------------------

@router.get("/labs/{lab_id}", response_model=LabDetail)
async def get_lab(
    lab_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User | None = Depends(get_optional_user),
):
    result = await db.execute(select(Lab).where(Lab.id == lab_id))
    lab = result.scalar_one_or_none()
    if not lab:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Lab not found")

    sec = (await db.execute(select(Section).where(Section.labs.contains([lab.id])))).scalars().first()
    sec_id = sec.id if sec else ""
    mod = (await db.execute(select(Module).where(Module.sections.contains([sec_id])))).scalars().first() if sec_id else None
    mod_id = mod.id if mod else ""

    analytics.track(
        "anonymous",
        AnalyticsEvent.LAB_STARTED,
        {
            "lab_id": lab.id,
            "module_id": mod_id,
            "section_id": sec_id,
            "title": lab.title,
        },
    )

    return LabDetail(
        id=lab.id,
        module_id=mod_id,
        section_id=sec_id,
        data=LabSchema(
            id=lab.id,
            title=lab.title,
            order=1,
            xp=lab.xp,
            estimated_minutes=lab.estimated_minutes,
            environment_profile=lab.environment_profile,
            seed_commands=lab.seed_commands,
            version=lab.version,
        ),
    )