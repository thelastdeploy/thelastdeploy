# web/backend/tests/test_module_f_onboarding.py

import pytest
import pytest_asyncio
import secrets
from httpx import AsyncClient, ASGITransport
from datetime import datetime, timezone, timedelta
from sqlalchemy import select

from main import app
from app.database import AsyncSessionLocal
from app.models import (
    User,
    Organization,
    OrganizationMembership,
    Role,
    MembershipRole,
    Cohort,
    CohortMembership,
    OrganizationInvitation,
    OrganizationAccessRequest,
    AuditLog,
)
from app.auth import hash_password
from app.settings.service import SettingsService

pytestmark = pytest.mark.asyncio


@pytest_asyncio.fixture
async def client():
    async with AsyncClient(base_url="http://127.0.0.1:9001", timeout=15.0) as ac:
        yield ac


@pytest_asyncio.fixture
async def db_session():
    from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession
    from app.config import settings
    from sqlalchemy.pool import NullPool

    engine = create_async_engine(settings.DATABASE_URL, poolclass=NullPool)
    session_maker = async_sessionmaker(engine, expire_on_commit=False, class_=AsyncSession)
    async with session_maker() as session:
        yield session
    await engine.dispose()


@pytest.mark.asyncio
async def test_subdomain_resolution_valid_and_invalid(client):
    # 1. Valid subdomain
    resp = await client.get("/onboarding/organization-info", headers={"Host": "apex-univ.org.thelastdeploy.com"})
    assert resp.status_code == 200
    data = resp.json()
    assert data["slug"] == "apex-univ"
    assert data["name"] == "Apex University"
    assert "apex.edu" in data["domains"]

    # 2. Invalid subdomain
    resp_invalid = await client.get("/onboarding/organization-info", headers={"Host": "fake-slug-xyz.org.thelastdeploy.com"})
    assert resp_invalid.status_code == 404

    # 3. Default root domain -> Platform Organization
    resp_root = await client.get("/onboarding/organization-info", headers={"Host": "thelastdeploy.com"})
    assert resp_root.status_code == 200
    assert resp_root.json()["slug"] == "tld"
    assert resp_root.json()["type"] == "platform"


@pytest.mark.asyncio
async def test_scoped_registration_institutional_vs_platform(client, db_session):
    unique_suffix = secrets.token_hex(4)

    # 1. Register through institutional subdomain
    apex_email = f"student_{unique_suffix}@apex.edu"
    apex_username = f"apex_{unique_suffix}"
    resp_apex = await client.post(
        "/register",
        headers={"Host": "apex-univ.org.thelastdeploy.com"},
        json={"email": apex_email, "username": apex_username, "password": "Password123!"},
    )
    assert resp_apex.status_code in (200, 201)

    # Check user memberships
    user_apex = await db_session.scalar(select(User).where(User.username == apex_username))
    assert user_apex is not None
    mems_apex = (await db_session.scalars(select(OrganizationMembership).where(OrganizationMembership.user_id == user_apex.id))).all()
    # Must belong to Apex University (id 13) and NOT to platform (id 1)
    org_ids = [m.organization_id for m in mems_apex]
    assert 13 in org_ids
    assert 1 not in org_ids

    # 2. Register through root platform domain
    tld_email = f"tld_{unique_suffix}@example.com"
    tld_username = f"tld_{unique_suffix}"
    resp_tld = await client.post(
        "/register",
        headers={"Host": "thelastdeploy.com"},
        json={"email": tld_email, "username": tld_username, "password": "Password123!"},
    )
    assert resp_tld.status_code in (200, 201)

    user_tld = await db_session.scalar(select(User).where(User.username == tld_username))
    assert user_tld is not None
    mems_tld = (await db_session.scalars(select(OrganizationMembership).where(OrganizationMembership.user_id == user_tld.id))).all()
    # Must belong to platform (id 1)
    assert any(m.organization_id == 1 for m in mems_tld)


@pytest.mark.asyncio
async def test_domain_based_eligibility_rejection(client):
    # Submitting an unauthorized domain on apex-univ should be rejected
    resp = await client.post(
        "/onboarding/access-request",
        headers={"Host": "apex-univ.org.thelastdeploy.com"},
        json={"email": f"hacker_{secrets.token_hex(3)}@gmail.com"},
    )
    assert resp.status_code == 400
    assert "not authorized" in resp.json()["detail"].lower()


@pytest.mark.asyncio
async def test_invitation_lifecycle_new_user_and_double_redeem(client, db_session):
    unique_suffix = secrets.token_hex(4)
    target_email = f"newstudent_{unique_suffix}@apex.edu"

    # 1. Issue invitation through admin endpoint (login sarah_apex)
    login_resp = await client.post("/login", json={"email": "sarah.apex@example.com", "password": "Password123!"})
    token = login_resp.json()["access_token"]

    create_resp = await client.post(
        "/organizations/invitations",
        headers={"Authorization": f"Bearer {token}", "X-Organization-Slug": "apex-univ"},
        json={"email": target_email},
    )
    assert create_resp.status_code == 200
    inv_data = create_resp.json()
    code = inv_data["invitation_code"]
    assert code is not None

    # 2. Verify invitation without consuming
    verify_resp = await client.post("/onboarding/invitations/verify", json={"code": code})
    assert verify_resp.status_code == 200
    assert verify_resp.json()["valid"] is True
    assert verify_resp.json()["is_existing_user"] is False
    assert verify_resp.json()["requires_password_setup"] is True

    # 3. Redeem invitation as new user -> yields onboarding token
    redeem_resp = await client.post("/onboarding/invitations/redeem", json={"code": code})
    assert redeem_resp.status_code == 200
    redeem_data = redeem_resp.json()
    assert redeem_data["requires_password_setup"] is True
    onboarding_token = redeem_data["onboarding_token"]

    # 4. Complete setup with password
    username = f"user_{unique_suffix}"
    complete_resp = await client.post(
        "/onboarding/invitations/complete-setup",
        json={"onboarding_token": onboarding_token, "username": username, "password": "SecurePassword123!"},
    )
    assert complete_resp.status_code == 200
    assert complete_resp.json()["status"] == "accepted"
    assert "access_token" in complete_resp.json()

    # Verify user exists in database with apex membership
    new_user = await db_session.scalar(select(User).where(User.username == username))
    assert new_user is not None
    mems = (await db_session.scalars(select(OrganizationMembership).where(OrganizationMembership.user_id == new_user.id))).all()
    assert any(m.organization_id == 13 for m in mems)
    assert not any(m.organization_id == 1 for m in mems)

    # 5. Double redeem attempt -> Must return 409 Conflict
    second_redeem = await client.post("/onboarding/invitations/redeem", json={"code": code})
    assert second_redeem.status_code == 409


@pytest.mark.asyncio
async def test_invitation_revocation_prevents_redemption(client):
    unique_suffix = secrets.token_hex(4)
    target_email = f"revoketest_{unique_suffix}@apex.edu"

    login_resp = await client.post("/login", json={"email": "sarah.apex@example.com", "password": "Password123!"})
    token = login_resp.json()["access_token"]

    create_resp = await client.post(
        "/organizations/invitations",
        headers={"Authorization": f"Bearer {token}", "X-Organization-Slug": "apex-univ"},
        json={"email": target_email},
    )
    inv_data = create_resp.json()
    inv_id = inv_data["id"]
    code = inv_data["invitation_code"]

    # Revoke invitation
    revoke_resp = await client.post(
        f"/organizations/invitations/{inv_id}/revoke",
        headers={"Authorization": f"Bearer {token}", "X-Organization-Slug": "apex-univ"},
    )
    assert revoke_resp.status_code == 200

    # Attempt to redeem revoked code -> 410 Gone
    redeem_resp = await client.post("/onboarding/invitations/redeem", json={"code": code})
    assert redeem_resp.status_code == 410


@pytest.mark.asyncio
async def test_cohort_invitation_establishes_org_and_cohort_membership(client, db_session):
    unique_suffix = secrets.token_hex(4)

    # 1. Create a cohort in Apex University if not present
    login_resp = await client.post("/login", json={"email": "sarah.apex@example.com", "password": "Password123!"})
    token = login_resp.json()["access_token"]

    now = datetime.now(timezone.utc)
    cohort_resp = await client.post(
        "/organizations/apex-univ/cohorts",
        headers={"Authorization": f"Bearer {token}", "X-Organization-Slug": "apex-univ"},
        json={
            "name": f"DevOps Cohort {unique_suffix}",
            "starts_at": now.isoformat(),
            "ends_at": (now + timedelta(days=60)).isoformat(),
        },
    )
    assert cohort_resp.status_code in (200, 201)
    cohort_id = cohort_resp.json()["id"]

    # 2. Invite student directly into cohort
    student_email = f"cohort_student_{unique_suffix}@apex.edu"
    invite_resp = await client.post(
        f"/organizations/cohorts/{cohort_id}/invitations",
        headers={"Authorization": f"Bearer {token}", "X-Organization-Slug": "apex-univ"},
        json={"email": student_email},
    )
    assert invite_resp.status_code == 200
    code = invite_resp.json()["invitation_code"]

    # 3. Redeem as new user
    redeem_resp = await client.post("/onboarding/invitations/redeem", json={"code": code})
    onboarding_token = redeem_resp.json()["onboarding_token"]

    username = f"cuser_{unique_suffix}"
    complete_resp = await client.post(
        "/onboarding/invitations/complete-setup",
        json={"onboarding_token": onboarding_token, "username": username, "password": "CohortPass123!"},
    )
    assert complete_resp.status_code == 200

    # 4. Verify both organization AND cohort memberships were established
    user = await db_session.scalar(select(User).where(User.username == username))
    assert user is not None

    org_mem = await db_session.scalar(
        select(OrganizationMembership).where(
            OrganizationMembership.user_id == user.id,
            OrganizationMembership.organization_id == 13,
        )
    )
    assert org_mem is not None and org_mem.status == "active"

    cohort_mem = await db_session.scalar(
        select(CohortMembership).where(
            CohortMembership.organization_membership_id == org_mem.id,
            CohortMembership.cohort_id == cohort_id,
        )
    )
    assert cohort_mem is not None
