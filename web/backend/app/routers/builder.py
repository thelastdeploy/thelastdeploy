# web/backend/app/routers/builder.py

import json
import base64
import httpx
import yaml
import hashlib
from datetime import datetime, timezone
from fastapi import APIRouter, Depends, HTTPException, status, BackgroundTasks
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, delete
from app.dependencies import get_db, get_current_user, get_current_organization
from app.models import (
    User, Module, Section, Lab, LabProgress, SectionProgress,
    Organization, OrganizationMembership
)
from app.services import log_audit_event
from app.schemas import (
    BuilderModuleInput,
    BuilderModuleResponse,
    BuilderDraftListItem,
)
from app.config import settings

router = APIRouter()


def _calculate_validator_hash(script: str | None) -> str | None:
    if not script:
        return None
    normalized = script.encode('utf-8').replace(b"\r\n", b"\n").rstrip()
    return hashlib.sha256(normalized).hexdigest()


async def push_to_github_task(module_id: str, files: dict, commit_message: str):
    """Background task to commit multiple files atomically using Git Data API."""
    if not settings.GITHUB_TOKEN:
        print("[GitHub Integration] GITHUB_TOKEN not configured. Skipping GitHub push.")
        return

    headers = {
        "Authorization": f"token {settings.GITHUB_TOKEN}",
        "Accept": "application/vnd.github.v3+json",
        "User-Agent": "DevLab-Backend"
    }
    repo = settings.CHALLENGES_REPO
    branch = settings.CHALLENGES_BRANCH

    async with httpx.AsyncClient(timeout=30.0) as client:
        try:
            # 1. Get reference for the target branch
            ref_url = f"https://api.github.com/repos/{repo}/git/ref/heads/{branch}"
            ref_resp = await client.get(ref_url, headers=headers)
            if ref_resp.status_code != 200:
                print(f"[GitHub Integration] Failed to get branch reference: {ref_resp.text}")
                return
            
            ref_data = ref_resp.json()
            base_commit_sha = ref_data["object"]["sha"]

            # 2. Get the base commit tree SHA
            commit_url = f"https://api.github.com/repos/{repo}/git/commits/{base_commit_sha}"
            commit_resp = await client.get(commit_url, headers=headers)
            if commit_resp.status_code != 200:
                print(f"[GitHub Integration] Failed to get base commit details: {commit_resp.text}")
                return
            
            commit_data = commit_resp.json()
            base_tree_sha = commit_data["tree"]["sha"]

            # 3. Create a new Tree containing the updated files
            tree_entries = []
            for filepath, content in files.items():
                tree_entries.append({
                    "path": filepath,
                    "mode": "100644",
                    "type": "blob",
                    "content": content
                })

            tree_url = f"https://api.github.com/repos/{repo}/git/trees"
            tree_payload = {
                "base_tree": base_tree_sha,
                "tree": tree_entries
            }
            tree_resp = await client.post(tree_url, headers=headers, json=tree_payload)
            if tree_resp.status_code not in (200, 201):
                print(f"[GitHub Integration] Failed to create git tree: {tree_resp.text}")
                return
            
            new_tree_sha = tree_resp.json()["sha"]

            # 4. Create the Commit object
            commits_url = f"https://api.github.com/repos/{repo}/git/commits"
            commit_payload = {
                "message": commit_message,
                "tree": new_tree_sha,
                "parents": [base_commit_sha]
            }
            new_commit_resp = await client.post(commits_url, headers=headers, json=commit_payload)
            if new_commit_resp.status_code not in (200, 201):
                print(f"[GitHub Integration] Failed to create commit: {new_commit_resp.text}")
                return
            
            new_commit_sha = new_commit_resp.json()["sha"]

            # 5. Update the Reference for the branch
            update_ref_url = f"https://api.github.com/repos/{repo}/git/refs/heads/{branch}"
            update_ref_payload = {
                "sha": new_commit_sha,
                "force": False
            }
            patch_resp = await client.patch(update_ref_url, headers=headers, json=update_ref_payload)
            if patch_resp.status_code != 200:
                print(f"[GitHub Integration] Failed to update reference: {patch_resp.text}")
                return

            print(f"[GitHub Integration] Successfully committed {len(files)} files to branch {branch} in 1 single atomic commit! (Commit SHA: {new_commit_sha})")

        except Exception as e:
            print(f"[GitHub Integration] Error performing atomic GitHub commit: {e}")


def build_github_challenge_files(
    module_id: str,
    title: str,
    description: str | None,
    topic: str,
    difficulty: str,
    estimated_minutes: int | None,
    tags: list[str] = [],
    sections: list[dict] = [],
    is_verified: bool = False,
    version: int = 1,
) -> dict[str, str]:
    github_files = {}
    base_path = f"challenges/{module_id}"

    module_yaml_data = {
        "id": module_id,
        "title": title,
        "description": description,
        "topic": topic,
        "difficulty": difficulty,
        "estimated_minutes": estimated_minutes,
        "version": version,
    }
    if is_verified:
        module_yaml_data["verified"] = True

    github_files[f"{base_path}/module.yaml"] = yaml.safe_dump(module_yaml_data, sort_keys=False)

    for sec in sections:
        sec_folder = f"{sec['order']:02d}-{sec['id']}"
        sec_base = f"{base_path}/sections/{sec_folder}"

        sec_yaml_data = {
            "id": sec["id"],
            "title": sec["title"],
            "order": sec["order"],
            "xp": sec["xp"],
        }
        github_files[f"{sec_base}/section.yaml"] = yaml.safe_dump(sec_yaml_data, sort_keys=False)

        if sec.get("content"):
            github_files[f"{sec_base}/content.md"] = sec["content"]

        for lab in sec.get("labs", []):
            lab_base = f"{sec_base}/labs/{lab['id']}"

            seed_cmds = lab.get("seed_commands")
            if isinstance(seed_cmds, str):
                try:
                    seed_cmds = json.loads(seed_cmds)
                except Exception:
                    pass

            lab_yaml_data = {
                "id": lab["id"],
                "title": lab["title"],
                "order": lab.get("order", 1),
                "xp": lab["xp"],
                "estimated_minutes": lab.get("estimated_minutes"),
                "environment": {
                    "profile": lab.get("environment_profile") or "tld-ubuntu",
                },
                "version": lab.get("version", 1),
            }
            if seed_cmds:
                lab_yaml_data["setup"] = {
                    "seed_commands": seed_cmds,
                }
            github_files[f"{lab_base}/lab.yaml"] = yaml.safe_dump(lab_yaml_data, sort_keys=False)

            val_script = lab.get("validator_script")
            if val_script:
                val_ext = "sh"
                if "import " in val_script or "def " in val_script:
                    val_ext = "py"
                github_files[f"{lab_base}/validator.{val_ext}"] = val_script

    return github_files


# ---------------------------------------------------------------------------
# POST /builder/modules (Publish/Submit a Module from the CLI)
# ---------------------------------------------------------------------------
@router.post("/builder/modules", response_model=BuilderModuleResponse, status_code=status.HTTP_201_CREATED)
async def publish_module_from_cli(
    body: BuilderModuleInput,
    background_tasks: BackgroundTasks,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
):
    organization, membership = org_and_mem

    # 1. Resolve module in current organization
    module_id = body.id if organization.is_platform else f"{organization.slug}-{body.id}"

    stmt = select(Module).where(
        Module.owner_organization_id == organization.id,
        Module.id == module_id,
    )
    result = await db.execute(stmt)
    existing_module = result.scalar_one_or_none()

    if existing_module:
        # If it exists, only the author or org admin can overwrite it, and only if it's not verified yet
        if existing_module.author_id is not None and existing_module.author_id != current_user.id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Module ID is already taken by another author in this organization",
            )
        if existing_module.status == "verified":
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Cannot modify or overwrite an officially verified module.",
            )

    # 2. Setup/overwrite Module row
    module_data = {
        "id": module_id,
        "owner_organization_id": organization.id,
        "title": body.title,
        "description": body.description,
        "topic": body.topic,
        "difficulty": body.difficulty,
        "estimated_minutes": body.estimated_minutes,
        "version": 1,
        "total_xp": 0,  # Unverified modules have 0 XP
        "author_id": current_user.id,
        "updated_by": current_user.id,
        "status": "published",
        "submitted_at": datetime.now(timezone.utc),
    }

    if existing_module:
        stmt_update_module = select(Module).where(Module.id == module_id)
        module = (await db.execute(stmt_update_module)).scalar_one()
        for key, val in module_data.items():
            setattr(module, key, val)
    else:
        module = Module(**module_data)
        db.add(module)
        await db.flush()

    # 3. Process Sections and Labs
    section_ids = []
    for s_input in body.sections:
        sec_id = s_input.id if organization.is_platform else f"{organization.slug}-{s_input.id}"
        section_ids.append(sec_id)

        lab_ids = []
        for l_input in s_input.labs:
            lab_id = l_input.id if organization.is_platform else f"{organization.slug}-{l_input.id}"
            lab_ids.append(lab_id)
            seed_cmds_json = json.dumps(l_input.seed_commands) if l_input.seed_commands else None
            val_hash = _calculate_validator_hash(l_input.validator_script)

            l_res = await db.execute(select(Lab).where(Lab.id == lab_id))
            lab = l_res.scalar_one_or_none()
            if not lab:
                lab = Lab(
                    id=lab_id,
                    owner_organization_id=organization.id,
                    title=l_input.title,
                    xp=0,
                    estimated_minutes=l_input.estimated_minutes,
                    seed_commands=seed_cmds_json,
                    version=1,
                    validator_hash=val_hash,
                    validator_script=l_input.validator_script,
                    created_by=current_user.id,
                )
                db.add(lab)
            else:
                lab.title = l_input.title
                lab.seed_commands = seed_cmds_json
                lab.validator_hash = val_hash
                lab.validator_script = l_input.validator_script
                db.add(lab)
            await db.flush()

        # Upsert section
        s_res = await db.execute(select(Section).where(Section.id == sec_id))
        section = s_res.scalar_one_or_none()
        if not section:
            section = Section(
                id=sec_id,
                owner_organization_id=organization.id,
                title=s_input.title,
                xp=0,
                content=s_input.content,
                labs=lab_ids,
                version=1,
                created_by=current_user.id,
            )
            db.add(section)
        else:
            section.title = s_input.title
            section.content = s_input.content
            section.labs = lab_ids
            db.add(section)
        await db.flush()

    module.sections = section_ids
    module.total_xp = 0

    await db.commit()
    await db.refresh(module)

    await log_audit_event(
        db,
        action="module.submitted",
        entity_type="module",
        entity_id=module.id,
        actor_user_id=current_user.id,
        organization_id=organization.id,
        metadata={"id": module.id, "sections_count": len(section_ids)},
    )

    # 4. Generate the YAML payload and trigger GitHub push in the background
    sections_data = [
        {
            "id": s.id,
            "title": s.title,
            "order": s.order,
            "xp": 0,
            "content": s.content,
            "labs": [
                {
                    "id": l.id,
                    "title": l.title,
                    "xp": 0,
                    "estimated_minutes": l.estimated_minutes,
                    "seed_commands": l.seed_commands,
                    "validator_script": l.validator_script,
                    "version": 1,
                }
                for l in s.labs
            ],
        }
        for s in body.sections
    ]
    github_files = build_github_challenge_files(
        module_id=body.id,
        title=body.title,
        description=body.description,
        topic=body.topic,
        difficulty=body.difficulty,
        estimated_minutes=body.estimated_minutes,
        tags=[],
        sections=sections_data,
        is_verified=False,
        version=1,
    )

    # Enqueue GitHub commit as a background task
    background_tasks.add_task(
        push_to_github_task,
        body.id,
        github_files,
        f"Add community challenge: {body.title}"
    )

    return BuilderModuleResponse(
        id=module.id,
        title=module.title,
        status=module.status,
        is_official_verified=(module.status == "verified"),
        total_sections=module.total_sections,
        total_xp=module.total_xp,
        created_at=module.created_at,
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
            is_official_verified=(m.status == "verified"),
            created_at=m.created_at,
            submitted_at=m.submitted_at,
        )
        for m in modules
    ]


# ---------------------------------------------------------------------------
# DELETE /builder/modules/{module_id} (Delete Module)
# ---------------------------------------------------------------------------
@router.delete("/builder/modules/{module_id}")
async def delete_module(
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

    # Only unverified modules can be deleted
    if module.status == "verified":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot delete a verified module."
        )

    # CASCADE delete Sections & Labs
    sec_ids = module.sections or []
    if sec_ids:
        sec_rows = (await db.execute(select(Section).where(Section.id.in_(sec_ids)))).scalars().all()
        lab_ids = [lid for s in sec_rows for lid in (s.labs or [])]
        if lab_ids:
            await db.execute(delete(LabProgress).where(LabProgress.lab_id.in_(lab_ids)))
            await db.execute(delete(Lab).where(Lab.id.in_(lab_ids)))
        await db.execute(delete(SectionProgress).where(SectionProgress.section_id.in_(sec_ids)))
        await db.execute(delete(Section).where(Section.id.in_(sec_ids)))

    await db.execute(delete(Module).where(Module.id == module_id))

    await db.commit()
    return {"detail": f"Module '{module_id}' deleted successfully."}
