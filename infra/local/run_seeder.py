# infra/local/run_seeder.py — automated database seeder entrypoint

import asyncio
import os
import sys
import time
import subprocess
from datetime import datetime, timezone, timedelta
from sqlalchemy import select

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from app.config import settings
from app.database import AsyncSessionLocal
from app.models import (
    User,
    Organization,
    OrganizationMembership,
    Role,
    PlatformPermission,
    PlatformUserPermission,
    Cohort,
    CohortMembership,
    LearningPath,
    OrganizationSetting,
)
from app.auth import hash_password
from app.services import seed_default_org_roles
from app.settings.registry import get_all_setting_definitions
from seed.seed_modules import seed as seed_modules


def wait_for_db():
    print("⏳ Waiting for database connection...")
    for i in range(30):
        try:
            result = subprocess.run(
                ["alembic", "current"],
                capture_output=True,
                text=True,
            )
            if result.returncode == 0:
                print("✓ Database connection established successfully.")
                return
            else:
                print(f"Waiting for DB ({i+1}/30)... output: {result.stderr.strip() or result.stdout.strip()}")
        except Exception as e:
            print(f"Waiting for DB ({i+1}/30)... error: {e}")
        time.sleep(2)
    raise RuntimeError("Timed out waiting for database connection.")


def run_migrations():
    print("🚀 Running Alembic migrations to construct production schema...")
    subprocess.run(["alembic", "upgrade", "head"], check=True)
    print("✓ Alembic schema migrations completed successfully.")


async def seed_organizations_and_settings(db):
    print("🏢 Ensuring organizations and settings availability...")
    orgs_def = [
        {
            "name": "The Last Deploy",
            "slug": "tld",
            "type": "platform",
            "is_platform": True,
            "domains": ["thelastdeploy.com"],
        },
        {
            "name": "Apex University",
            "slug": "apex-univ",
            "type": "university",
            "is_platform": False,
            "domains": ["apex.edu"],
        },
        {
            "name": "CloudScale Technologies",
            "slug": "cloudscale",
            "type": "company",
            "is_platform": False,
            "domains": ["cloudscale.io"],
        },
    ]

    org_map = {}
    for odef in orgs_def:
        org = (await db.execute(select(Organization).where(Organization.slug == odef["slug"]))).scalar_one_or_none()
        if not org:
            org = Organization(
                name=odef["name"],
                slug=odef["slug"],
                type=odef["type"],
                domains=odef["domains"],
                status="active",
            )
            db.add(org)
            await db.flush()
            print(f"  ✅ Created organization: {org.name} ({org.slug})")
        else:
            org.domains = odef["domains"]
        org_map[odef["slug"]] = org

    # Seed organization settings and default org-scoped roles for each organization
    all_defs = get_all_setting_definitions()
    for slug, org in org_map.items():
        has_roles = (await db.execute(
            select(Role.id).where(Role.organization_id == org.id).limit(1)
        )).scalar_one_or_none()
        if not has_roles:
            await seed_default_org_roles(db, org.id)
            print(f"  ✅ Seeded default roles for organization: {org.slug}")

        for sdef in all_defs:
            key = sdef.key
            setting = (await db.execute(
                select(OrganizationSetting).where(
                    OrganizationSetting.organization_id == org.id,
                    OrganizationSetting.setting_key == key,
                )
            )).scalar_one_or_none()
            if not setting:
                db.add(OrganizationSetting(
                    organization_id=org.id,
                    setting_key=key,
                    value=sdef.default,
                    is_enabled=True,
                ))
            elif not setting.is_enabled:
                setting.is_enabled = True

    # Seed Cohorts for Apex University and CloudScale
    apex_org = org_map.get("apex-univ")
    if apex_org:
        cohort = (await db.execute(select(Cohort).where(Cohort.organization_id == apex_org.id, Cohort.name == "Fall 2026 DevOps Cohort"))).scalar_one_or_none()
        if not cohort:
            now = datetime.now(timezone.utc)
            db.add(Cohort(
                organization_id=apex_org.id,
                name="Fall 2026 DevOps Cohort",
                description="Introductory Linux and Containerization Cohort for CS Department.",
                status="active",
                starts_at=now,
                ends_at=now + timedelta(days=90),
            ))
            print("  ✅ Created cohort: Fall 2026 DevOps Cohort (Apex University)")

        # Seed Learning Paths for Apex University using strictly Apex University's catalog modules
        apex_learning_paths = [
            {
                "name": "Systems Engineering & Linux Internals",
                "slug": "apex-systems-engineering",
                "description": "Deep dive into kernel interfaces, system calls, memory management, and POSIX tooling.",
                "visibility": "public",
                "status": "active",
                "modules": ["apex-univ-linux-fundamentals", "apex-linux-systems"],
            },
            {
                "name": "Cloud Microservices & Containers",
                "slug": "apex-cloud-microservices",
                "description": "Container runtime architecture, multi-container orchestration, and service mesh fundamentals.",
                "visibility": "public",
                "status": "active",
                "modules": ["apex-cloud-containers"],
            },
            {
                "name": "DevOps Foundations",
                "slug": "devops-foundations",
                "description": "Core Linux, system architecture, and cloud container workflows for CS students.",
                "visibility": "public",
                "status": "active",
                "modules": ["apex-univ-linux-fundamentals", "apex-cloud-containers"],
            },
        ]

        for lp_data in apex_learning_paths:
            lp = (await db.execute(
                select(LearningPath).where(
                    LearningPath.organization_id == apex_org.id,
                    LearningPath.slug == lp_data["slug"],
                )
            )).scalar_one_or_none()

            if not lp:
                db.add(LearningPath(
                    organization_id=apex_org.id,
                    name=lp_data["name"],
                    slug=lp_data["slug"],
                    description=lp_data["description"],
                    visibility=lp_data["visibility"],
                    status=lp_data["status"],
                    modules=lp_data["modules"],
                ))
                print(f"  ✅ Created learning path: {lp_data['name']} (Apex University)")
            else:
                lp.name = lp_data["name"]
                lp.description = lp_data["description"]
                lp.modules = lp_data["modules"]
                lp.visibility = lp_data["visibility"]
                lp.status = lp_data["status"]
                print(f"  🔄 Updated learning path: {lp_data['name']} (Apex University)")

    await db.flush()
    return org_map


async def seed_users(db, org_map):
    print("👤 Seeding development users matrix...")
    default_pw_hash = hash_password("Password123!")

    # Fetch all platform permissions into map
    all_perm_objs = (await db.execute(select(PlatformPermission))).scalars().all()
    perm_map = {p.key: p for p in all_perm_objs}
    all_perm_keys = list(perm_map.keys())

    # Fetch org-scoped roles per organization
    org_roles_map: dict[int, dict[str, Role]] = {}
    for org in org_map.values():
        roles_res = (await db.execute(select(Role).where(Role.organization_id == org.id))).scalars().all()
        org_roles_map[org.id] = {r.slug: r for r in roles_res}

    # User definitions: username, email, platform_roles, memberships: [{ org_slug, roles, xp }]
    users_matrix = [
        # Platform Staff
        {
            "username": "devuser",
            "email": "dev@example.com",
            "platform_roles": [],
            "platform_permissions": all_perm_keys,
            "memberships": [{"org_slug": "tld", "roles": ["owner", "admin"], "xp": 40}],
        },
        {
            "username": "testdev",
            "email": "testdev@example.com",
            "platform_roles": [],
            "platform_permissions": all_perm_keys,
            "memberships": [{"org_slug": "tld", "roles": ["owner", "admin"], "xp": 55}],
        },
        {
            "username": "kai_curriculum",
            "email": "kai.curriculum@example.com",
            "platform_roles": [],
            "platform_permissions": [
                "platform.analytics.view",
                "platform.organizations.view",
            ],
            "memberships": [{"org_slug": "tld", "roles": ["instructor"], "xp": 180}],
        },
        {
            "username": "sam_support",
            "email": "sam.support@example.com",
            "platform_roles": [],
            "platform_permissions": [
                "platform.organizations.view",
                "platform.analytics.view",
                "platform.audit.view",
            ],
            "memberships": [{"org_slug": "tld", "roles": ["learner"], "xp": 50}],
        },
        {
            "username": "elena_auditor",
            "email": "elena.auditor@example.com",
            "platform_roles": [],
            "platform_permissions": [
                "platform.audit.view",
                "platform.analytics.view",
                "platform.analytics.export",
            ],
            "memberships": [{"org_slug": "tld", "roles": ["learner"], "xp": 60}],
        },
        {
            "username": "nora_onboarding",
            "email": "nora.onboarding@example.com",
            "platform_roles": [],
            "platform_permissions": [
                "platform.organizations.view",
                "platform.organizations.create",
                "platform.organizations.settings",
            ],
            "memberships": [{"org_slug": "tld", "roles": ["learner"], "xp": 90}],
        },
        {
            "username": "alex_operator",
            "email": "alex.operator@example.com",
            "platform_roles": [],
            "platform_permissions": [],
            "memberships": [{"org_slug": "tld", "roles": ["learner"], "xp": 10}],
        },
        # Platform-only Learners
        {
            "username": "maya_tld",
            "email": "maya.platform@example.com",
            "platform_roles": [],
            "memberships": [{"org_slug": "tld", "roles": ["learner"], "xp": 120}],
        },
        {
            "username": "leo_tld",
            "email": "leo.platform@example.com",
            "platform_roles": [],
            "memberships": [{"org_slug": "tld", "roles": ["learner"], "xp": 45}],
        },
        {
            "username": "raja",
            "email": "raja@tld.dev",
            "platform_roles": [],
            "memberships": [{"org_slug": "tld", "roles": ["learner"], "xp": 265}],
        },
        {
            "username": "zane_tld",
            "email": "zane.platform@example.com",
            "platform_roles": [],
            "memberships": [{"org_slug": "tld", "roles": ["learner"], "xp": 350}],
        },
        {
            "username": "priya_tld",
            "email": "priya.platform@example.com",
            "platform_roles": [],
            "memberships": [{"org_slug": "tld", "roles": ["learner"], "xp": 0}],
        },
        # Apex University
        {
            "username": "sarah_apex",
            "email": "sarah.apex@example.com",
            "platform_roles": [],
            "memberships": [
                {"org_slug": "apex-univ", "roles": ["admin", "instructor"], "xp": 0},
            ],
        },
        {
            "username": "ethan_apex",
            "email": "ethan.apex@example.com",
            "platform_roles": [],
            "platform_permissions": ["platform.modules.view_all", "platform.modules.verify"],
            "memberships": [
                {"org_slug": "apex-univ", "roles": ["learner"], "xp": 80},
                {"org_slug": "tld", "roles": ["instructor"], "xp": 80},
            ],
        },
        {
            "username": "student_apex1",
            "email": "student1@apex.edu",
            "platform_roles": [],
            "memberships": [{"org_slug": "apex-univ", "roles": ["learner"], "xp": 0}],
        },
        # CloudScale Technologies
        {
            "username": "marcus_cloud",
            "email": "marcus.cloud@example.com",
            "platform_roles": [],
            "memberships": [{"org_slug": "cloudscale", "roles": ["admin"], "xp": 0}],
        },
        {
            "username": "zara_cloud",
            "email": "zara.cloud@example.com",
            "platform_roles": [],
            "memberships": [
                {"org_slug": "cloudscale", "roles": ["learner"], "xp": 150},
                {"org_slug": "tld", "roles": ["learner"], "xp": 150},
            ],
        },
        # Multi-Organization Users
        {
            "username": "alex_multi",
            "email": "alex.multiorg@example.com",
            "platform_roles": [],
            "memberships": [
                {"org_slug": "tld", "roles": ["learner"], "xp": 320},
                {"org_slug": "apex-univ", "roles": ["learner"], "xp": 110},
            ],
        },
        {
            "username": "elena_dual",
            "email": "elena.dual@example.com",
            "platform_roles": [],
            "memberships": [
                {"org_slug": "apex-univ", "roles": ["instructor"], "xp": 50},
                {"org_slug": "cloudscale", "roles": ["learner"], "xp": 95},
                {"org_slug": "tld", "roles": ["learner"], "xp": 145},
            ],
        },
        {
            "username": "jordan_global",
            "email": "jordan.global@example.com",
            "platform_roles": [],
            "memberships": [
                {"org_slug": "cloudscale", "roles": ["admin"], "xp": 240},
                {"org_slug": "apex-univ", "roles": ["learner"], "xp": 180},
                {"org_slug": "tld", "roles": ["learner"], "xp": 740},
            ],
        },
    ]

    for udef in users_matrix:
        user = (await db.execute(select(User).where(User.email == udef["email"]))).scalar_one_or_none()
        if not user:
            user = User(
                username=udef["username"],
                email=udef["email"],
                password_hash=default_pw_hash,
                is_verified=True,
            )
            db.add(user)
            await db.flush()
            print(f"  ✅ Created user: {user.username} ({user.email})")
        else:
            # Ensure password is Password123!
            user.password_hash = default_pw_hash
            user.is_verified = True

        # Direct Platform Permissions
        for pkey in udef.get("platform_permissions", []):
            perm_obj = perm_map.get(pkey)
            if perm_obj:
                has_perm = (await db.scalar(
                    select(PlatformUserPermission.id).where(
                        PlatformUserPermission.user_id == user.id,
                        PlatformUserPermission.permission_id == perm_obj.id,
                    )
                )) is not None
                if not has_perm:
                    db.add(PlatformUserPermission(user_id=user.id, permission_id=perm_obj.id))

        # Memberships
        for mdef in udef["memberships"]:
            target_org = org_map.get(mdef["org_slug"])
            if not target_org:
                continue
            role_lookup = org_roles_map.get(target_org.id, {})

            mem = (await db.execute(select(OrganizationMembership).where(
                OrganizationMembership.user_id == user.id,
                OrganizationMembership.organization_id == target_org.id,
            ))).scalar_one_or_none()

            primary_slug = mdef["roles"][0] if mdef["roles"] else "learner"
            r_obj = role_lookup.get(primary_slug)
            if not r_obj:
                continue

            if not mem:
                mem = OrganizationMembership(
                    organization_id=target_org.id,
                    user_id=user.id,
                    role_id=r_obj.id,
                    status="active",
                    total_xp=mdef["xp"],
                    unverified_xp=0,
                )
                db.add(mem)
                await db.flush()
            else:
                mem.total_xp = mdef["xp"]
                mem.role_id = r_obj.id

    await db.commit()
    print("✓ User matrix and permissions successfully seeded.")


async def main():
    wait_for_db()
    run_migrations()
    await seed_modules()
    async with AsyncSessionLocal() as db:
        org_map = await seed_organizations_and_settings(db)
        await seed_users(db, org_map)
    print("\n🎉 Database initialization and complete seeding completed successfully!")


if __name__ == "__main__":
    asyncio.run(main())
