# infra/local/run_seeder.py — automated database seeder entrypoint

import asyncio
import os
import sys
import time
import subprocess
from sqlalchemy import select

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from app.config import settings
from app.database import AsyncSessionLocal
from app.models import User, Organization, OrganizationMembership, Role, MembershipRole, PlatformRole, PlatformUserRole
from app.auth import hash_password
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


async def seed_dummy_users():
    print("👤 Seeding initial dev user accounts...")
    async with AsyncSessionLocal() as db:
        dev_email = "dev@example.com"
        result = await db.execute(select(User).where(User.email == dev_email))
        existing_user = result.scalar_one_or_none()

        if not existing_user:
            dev_user = User(
                username="devuser",
                email=dev_email,
                password_hash=hash_password("password123"),
                is_verified=True,
            )
            db.add(dev_user)
            await db.flush()

            platform_org = (await db.execute(select(Organization).where(Organization.type == "platform"))).scalar_one_or_none()
            if platform_org:
                mem = OrganizationMembership(
                    organization_id=platform_org.id,
                    user_id=dev_user.id,
                    total_xp=500,
                    unverified_xp=0,
                )
                db.add(mem)
                await db.flush()

                admin_role = (await db.execute(select(Role).where(Role.slug == "admin"))).scalar_one_or_none()
                if admin_role:
                    db.add(MembershipRole(membership_id=mem.id, role_id=admin_role.id))

                plat_role = (await db.execute(select(PlatformRole).where(PlatformRole.slug == "platform_admin"))).scalar_one_or_none()
                if plat_role:
                    db.add(PlatformUserRole(user_id=dev_user.id, platform_role_id=plat_role.id))

            await db.commit()
            print("  ✅ Created dev user: dev@example.com (password: password123)")
        else:
            print("  ⏭ Dev user dev@example.com already exists.")


async def main():
    wait_for_db()
    run_migrations()
    await seed_modules()
    await seed_dummy_users()
    print("\n🎉 Database initialization and seeding completed successfully!")


if __name__ == "__main__":
    asyncio.run(main())
