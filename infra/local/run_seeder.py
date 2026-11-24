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
    MembershipRole,
    PlatformRole,
    PlatformUserRole,
    PlatformPermission,
    PlatformUserPermission,
    PlatformRolePermission,
    Cohort,
    CohortMembership,
    LearningPath,
    OrganizationSettingAvailability,
    OrganizationSetting,
)
from app.auth import hash_password
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

    # Seed organization settings availability for each organization
    all_defs = get_all_setting_definitions()
    for slug, org in org_map.items():
        for sdef in all_defs:
            key = sdef.key
            avail = (await db.execute(
                select(OrganizationSettingAvailability).where(
                    OrganizationSettingAvailability.organization_id == org.id,
                    OrganizationSettingAvailability.setting_key == key,
                )
            )).scalar_one_or_none()

            if not avail:
                db.add(OrganizationSettingAvailability(
                    organization_id=org.id,
                    setting_key=key,
                    is_enabled=True,
                ))

            # Default setting value
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
                ))

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

        # Seed Learning Path
        lp = (await db.execute(select(LearningPath).where(LearningPath.organization_id == apex_org.id, LearningPath.slug == "devops-foundations"))).scalar_one_or_none()
        if not lp:
            db.add(LearningPath(
                organization_id=apex_org.id,
                name="DevOps Foundations",
                slug="devops-foundations",
                description="Core Linux, Bash scripting, and Git workflows.",
                visibility="organization",
                status="published",
                modules=["linux-fundamentals", "bash-scripting", "git-mastery"],
            ))
            print("  ✅ Created learning path: DevOps Foundations (Apex University)")

    await db.flush()
    return org_map


async def seed_users(db, org_map):
    print("👤 Seeding development users matrix...")
    default_pw_hash = hash_password("Password123!")

    # Fetch platform roles
    plat_admin_role = (await db.execute(select(PlatformRole).where(PlatformRole.slug == "platform_admin"))).scalar_one_or_none()
    curr_lead_role = (await db.execute(select(PlatformRole).where(PlatformRole.slug == "curriculum_lead"))).scalar_one_or_none()
    support_role = (await db.execute(select(PlatformRole).where(PlatformRole.slug == "support_staff"))).scalar_one_or_none()

    # Ensure platform permission 'organization_settings.manage' exists
    from app.models import PlatformPermission, PlatformRolePermission
    org_settings_perm = (await db.execute(select(PlatformPermission).where(PlatformPermission.key == "organization_settings.manage"))).scalar_one_or_none()
    if not org_settings_perm:
        org_settings_perm = PlatformPermission(
            key="organization_settings.manage",
            description="Manage workspace and organization settings across all organizations",
        )
        db.add(org_settings_perm)
        await db.flush()
        print("  ✅ Created platform permission: organization_settings.manage")

    if plat_admin_role and org_settings_perm:
        has_perm = (await db.execute(
            select(PlatformRolePermission).where(
                PlatformRolePermission.platform_role_id == plat_admin_role.id,
                PlatformRolePermission.permission_id == org_settings_perm.id,
            )
        )).scalar_one_or_none()
        if not has_perm:
            db.add(PlatformRolePermission(
                platform_role_id=plat_admin_role.id,
                permission_id=org_settings_perm.id,
            ))
            await db.flush()
            print("  ✅ Linked organization_settings.manage to platform_admin role")

    # Fetch all platform permissions into map
    all_perm_objs = (await db.execute(select(PlatformPermission))).scalars().all()
    perm_map = {p.key: p for p in all_perm_objs}
    all_perm_keys = list(perm_map.keys())

    # Fetch org roles
    role_owner = (await db.execute(select(Role).where(Role.slug == "owner"))).scalar_one_or_none()
    role_admin = (await db.execute(select(Role).where(Role.slug == "admin"))).scalar_one_or_none()
    role_instructor = (await db.execute(select(Role).where(Role.slug == "instructor"))).scalar_one_or_none()
    role_learner = (await db.execute(select(Role).where(Role.slug == "learner"))).scalar_one_or_none()

    role_lookup = {
        "owner": role_owner,
        "admin": role_admin,
        "instructor": role_instructor,
        "learner": role_learner,
    }

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
                "platform.modules.view_all",
                "platform.modules.verify",
                "platform.modules.calibrate_xp",
                "platform.modules.reject",
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
            "platform_roles": [curr_lead_role],
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

        # Platform Roles
        for pr in udef["platform_roles"]:
            if pr:
                has_pr = (await db.execute(select(PlatformUserRole).where(
                    PlatformUserRole.user_id == user.id,
                    PlatformUserRole.platform_role_id == pr.id,
                ))).scalar_one_or_none()
                if not has_pr:
                    db.add(PlatformUserRole(user_id=user.id, platform_role_id=pr.id))

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

            mem = (await db.execute(select(OrganizationMembership).where(
                OrganizationMembership.user_id == user.id,
                OrganizationMembership.organization_id == target_org.id,
            ))).scalar_one_or_none()

            if not mem:
                mem = OrganizationMembership(
                    organization_id=target_org.id,
                    user_id=user.id,
                    status="active",
                    total_xp=mdef["xp"],
                    unverified_xp=0,
                )
                db.add(mem)
                await db.flush()

                for r_slug in mdef["roles"]:
                    r_obj = role_lookup.get(r_slug)
                    if r_obj:
                        db.add(MembershipRole(membership_id=mem.id, role_id=r_obj.id))
            else:
                mem.total_xp = mdef["xp"]
                # Ensure roles exist
                for r_slug in mdef["roles"]:
                    r_obj = role_lookup.get(r_slug)
                    if r_obj:
                        has_r = (await db.execute(select(MembershipRole).where(
                            MembershipRole.membership_id == mem.id,
                            MembershipRole.role_id == r_obj.id,
                        ))).scalar_one_or_none()
                        if not has_r:
                            db.add(MembershipRole(membership_id=mem.id, role_id=r_obj.id))

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
