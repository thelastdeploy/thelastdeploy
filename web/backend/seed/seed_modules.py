# web/backend/seed/seed_modules.py — database seeder for challenges and modules

import asyncio
import hashlib
import json
import os
import subprocess
import sys
import yaml

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from sqlalchemy import select
from app.database import AsyncSessionLocal
from app.models import Module, Section, Lab, Organization

CHALLENGES_DIR = os.getenv(
    "CHALLENGES_DIR",
    os.path.abspath(
        os.path.join(os.path.dirname(__file__), "..", "..", "..", "challenges")
    ),
)


def run_migrations():
    """Ensure database schema is up-to-date with Alembic migrations before seeding."""
    backend_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    try:
        res = subprocess.run(
            ["alembic", "upgrade", "head"],
            cwd=backend_dir,
            capture_output=True,
            text=True,
        )
        if res.returncode == 0:
            print("🚀 Alembic schema migrations ensured.")
        else:
            print(f"⚠️ Alembic notice: {res.stdout.strip()} {res.stderr.strip()}")
    except Exception as e:
        print(f"⚠️ Alembic execution notice: {e}")


async def seed():
    run_migrations()
    print(f"🌱 Seeding challenge modules from: {CHALLENGES_DIR}")
    async with AsyncSessionLocal() as db:
        # Resolve platform organization (The Last Deploy)
        plat_res = await db.execute(select(Organization).where(Organization.type == "platform"))
        platform_org = plat_res.scalar_one_or_none()
        platform_org_id = platform_org.id if platform_org else 1

        for module_dir in sorted(os.listdir(CHALLENGES_DIR)):
            module_path = os.path.join(CHALLENGES_DIR, module_dir)
            module_yaml_path = os.path.join(module_path, "module.yaml")

            if not os.path.isdir(module_path) or not os.path.exists(module_yaml_path):
                continue

            with open(module_yaml_path) as f:
                raw_yaml = f.read()
                module_data = yaml.safe_load(raw_yaml)

            module_id = module_data["id"]

            # ── Process Sections and Labs ──────────────────────────────
            total_xp = 0
            module_section_ids = []
            sections_dir = os.path.join(module_path, "sections")

            if os.path.isdir(sections_dir):
                # Sort sections by order
                section_dirs_with_order = []
                for s_dir in os.listdir(sections_dir):
                    s_path = os.path.join(sections_dir, s_dir)
                    s_yaml = os.path.join(s_path, "section.yaml")
                    if os.path.isdir(s_path) and os.path.exists(s_yaml):
                        with open(s_yaml) as sf:
                            s_data = yaml.safe_load(sf)
                            order = s_data.get("order", 999)
                        section_dirs_with_order.append((order, s_dir))

                section_dirs_with_order.sort(key=lambda x: x[0])

                for _, section_dir in section_dirs_with_order:
                    section_path = os.path.join(sections_dir, section_dir)
                    section_yaml_path = os.path.join(section_path, "section.yaml")
                    content_path = os.path.join(section_path, "content.md")

                    with open(section_yaml_path) as f:
                        section_data = yaml.safe_load(f)

                    content = None
                    if os.path.exists(content_path):
                        with open(content_path) as f:
                            content = f.read()

                    section_id = section_data["id"]
                    module_section_ids.append(section_id)
                    total_xp += section_data.get("xp", 10)

                    # ── Process Labs for this section ───────────────────
                    section_lab_ids = []
                    labs_dir = os.path.join(section_path, "labs")

                    if os.path.isdir(labs_dir):
                        lab_dirs_with_order = []
                        for l_dir in os.listdir(labs_dir):
                            l_path = os.path.join(labs_dir, l_dir)
                            l_yaml = os.path.join(l_path, "lab.yaml")
                            if os.path.isdir(l_path) and os.path.exists(l_yaml):
                                with open(l_yaml) as lf:
                                    l_data = yaml.safe_load(lf)
                                    l_order = l_data.get("order", 999)
                                lab_dirs_with_order.append((l_order, l_dir))

                        lab_dirs_with_order.sort(key=lambda x: x[0])

                        for _, lab_dir in lab_dirs_with_order:
                            lab_path = os.path.join(labs_dir, lab_dir)
                            lab_yaml_path = os.path.join(lab_path, "lab.yaml")

                            with open(lab_yaml_path) as f:
                                lab_data = yaml.safe_load(f)

                            lab_id = lab_data["id"]
                            section_lab_ids.append(lab_id)
                            total_xp += lab_data.get("xp", 0)

                            # Validator script & hash
                            validator_hash = None
                            validator_script = None
                            validator_sh = os.path.join(lab_path, "validator.sh")
                            if os.path.exists(validator_sh):
                                with open(validator_sh, "rb") as f:
                                    c_bytes = f.read()
                                c_norm = c_bytes.replace(b"\r\n", b"\n").rstrip()
                                validator_hash = hashlib.sha256(c_norm).hexdigest()
                                validator_script = c_bytes.decode("utf-8", errors="replace")

                            setup_obj = lab_data.get("setup") or {}
                            if not isinstance(setup_obj, dict):
                                setup_obj = {}
                            seed_cmds = lab_data.get("seed_commands") or setup_obj.get("seed_commands") or []
                            seed_cmds_json = json.dumps(seed_cmds) if seed_cmds else None

                            env_obj = lab_data.get("environment") or {}
                            env_profile = env_obj.get("profile", "tld-ubuntu") if isinstance(env_obj, dict) else "tld-ubuntu"

                            # Upsert Lab
                            l_res = await db.execute(select(Lab).where(Lab.id == lab_id))
                            existing_lab = l_res.scalar_one_or_none()
                            if existing_lab:
                                existing_lab.owner_organization_id = platform_org_id
                                existing_lab.title = lab_data["title"]
                                existing_lab.xp = lab_data.get("xp", 0)
                                existing_lab.estimated_minutes = lab_data.get("estimated_minutes")
                                existing_lab.environment_profile = env_profile
                                existing_lab.seed_commands = seed_cmds_json
                                existing_lab.version = lab_data.get("version", 1)
                                existing_lab.validator_hash = validator_hash
                                existing_lab.validator_script = validator_script
                                db.add(existing_lab)
                            else:
                                db.add(Lab(
                                    id=lab_id,
                                    owner_organization_id=platform_org_id,
                                    title=lab_data["title"],
                                    xp=lab_data.get("xp", 0),
                                    estimated_minutes=lab_data.get("estimated_minutes"),
                                    environment_profile=env_profile,
                                    seed_commands=seed_cmds_json,
                                    version=lab_data.get("version", 1),
                                    validator_hash=validator_hash,
                                    validator_script=validator_script,
                                ))

                    # Upsert Section
                    s_res = await db.execute(select(Section).where(Section.id == section_id))
                    existing_section = s_res.scalar_one_or_none()
                    if existing_section:
                        existing_section.owner_organization_id = platform_org_id
                        existing_section.title = section_data["title"]
                        existing_section.xp = section_data.get("xp", 10)
                        existing_section.content = content
                        existing_section.labs = section_lab_ids
                        existing_section.version = section_data.get("version", 1)
                        db.add(existing_section)
                    else:
                        db.add(Section(
                            id=section_id,
                            owner_organization_id=platform_org_id,
                            title=section_data["title"],
                            xp=section_data.get("xp", 10),
                            content=content,
                            labs=section_lab_ids,
                            version=section_data.get("version", 1),
                        ))

            # ── Upsert Module ──────────────────────────────────────────
            m_res = await db.execute(select(Module).where(Module.id == module_id))
            existing_module = m_res.scalar_one_or_none()
            shared_seed = module_data.get("shared_seed") or None

            if existing_module:
                if existing_module.author_id is not None:
                    print(f"  ⏭ Skipping community module: {module_id}")
                    continue
                existing_module.owner_organization_id = platform_org_id
                existing_module.title = module_data["title"]
                existing_module.description = module_data.get("description")
                existing_module.topic = module_data.get("topic")
                existing_module.difficulty = module_data.get("difficulty")
                existing_module.estimated_minutes = module_data.get("estimated_minutes")
                existing_module.version = module_data.get("version", 1)
                existing_module.total_xp = total_xp
                existing_module.sections = module_section_ids
                existing_module.shared_seed = shared_seed
                existing_module.author_id = None
                existing_module.status = 'verified'
                db.add(existing_module)
                print(f"  ↻ Updated module: {module_id} (total_xp: {total_xp}, sections: {len(module_section_ids)})")
            else:
                db.add(Module(
                    id=module_id,
                    owner_organization_id=platform_org_id,
                    title=module_data["title"],
                    description=module_data.get("description"),
                    topic=module_data.get("topic"),
                    difficulty=module_data.get("difficulty"),
                    estimated_minutes=module_data.get("estimated_minutes"),
                    version=module_data.get("version", 1),
                    total_xp=total_xp,
                    sections=module_section_ids,
                    shared_seed=shared_seed,
                    author_id=None,
                    status='verified',
                ))
                print(f"  ✅ Seeded module: {module_id} (total_xp: {total_xp}, sections: {len(module_section_ids)})")

        await db.commit()
        print("\nDone.")


if __name__ == "__main__":
    asyncio.run(seed())
