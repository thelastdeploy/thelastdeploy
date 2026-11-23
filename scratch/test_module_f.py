"""
Comprehensive Test Suite for Module F: Invitations & Organization Onboarding
Verifying New User Onboarding, Existing User Multi-Org Onboarding, Domain Eligibility,
Cohort Invitations, Bulk CSV, Access Requests, Invitation Lifecycle, and Security.
"""

import sys
import uuid
import subprocess
import requests

API_BASE = "http://localhost:9001"

def print_header(title: str):
    print(f"\n{'='*70}\n[TEST] {title}\n{'='*70}")

def assert_true(cond: bool, msg: str):
    if not cond:
        print(f"❌ FAIL: {msg}")
        sys.exit(1)
    print(f"✅ PASS: {msg}")

def run_sql(query: str) -> str:
    res = subprocess.run(
        ["docker", "exec", "-i", "tld-db", "psql", "-U", "tld", "-d", "tld_db", "-t", "-A", "-c", query],
        capture_output=True,
        text=True,
        check=True
    )
    return res.stdout.strip()

def main():
    print_header("1. CONTEXT SETUP & ADMIN AUTHENTICATION")
    
    # 1. Login platform devuser
    login_dev = requests.post(f"{API_BASE}/login", json={"email": "dev@example.com", "password": "devpassword123"})
    assert_true(login_dev.status_code == 200, "Platform devuser login succeeds")
    dev_token = login_dev.json()["access_token"]
    dev_headers = {"Authorization": f"Bearer {dev_token}"}
    
    # 2. Login Apex University org admin (Sarah Apex)
    login_sarah = requests.post(f"{API_BASE}/login", json={"email": "sarah.apex@example.com", "password": "Password123!"})
    assert_true(login_sarah.status_code == 200, "Apex org admin login succeeds")
    sarah_token = login_sarah.json()["access_token"]
    sarah_headers = {"Authorization": f"Bearer {sarah_token}", "X-Organization-Slug": "apex-univ"}

    # 3. Create a learner user for unauthorized permission testing
    learner_uuid = uuid.uuid4().hex[:6]
    learner_email = f"learner_{learner_uuid}@example.com"
    reg_learner = requests.post(f"{API_BASE}/register", json={
        "email": learner_email,
        "username": f"learner_{learner_uuid}",
        "password": "Password123!"
    })
    assert_true(reg_learner.status_code in (200, 201), "Learner registered")
    login_learner = requests.post(f"{API_BASE}/login", json={"email": learner_email, "password": "Password123!"})
    learner_token = login_learner.json()["access_token"]
    learner_headers = {"Authorization": f"Bearer {learner_token}", "X-Organization-Slug": "apex-univ"}

    print_header("2. INVITATION CREATION & PERMISSION ENFORCEMENT")

    # A. Unauthorized learner cannot create invitations
    unauth_invite = requests.post(
        f"{API_BASE}/organizations/invitations",
        headers=learner_headers,
        json={"email": f"target_{learner_uuid}@apex.edu"}
    )
    assert_true(unauth_invite.status_code == 403, "Learner without members.manage cannot create invitations (403)")

    # B. Org Admin successfully invites new user
    invite_uuid = uuid.uuid4().hex[:6]
    target_new_email = f"new_student_{invite_uuid}@apex.edu"
    create_invite_resp = requests.post(
        f"{API_BASE}/organizations/invitations",
        headers=sarah_headers,
        json={"email": target_new_email}
    )
    assert_true(create_invite_resp.status_code == 200, "Org Admin successfully creates invitation")
    inv_data = create_invite_resp.json()
    inv_id = inv_data["id"]
    code = inv_data["invitation_code"]
    assert_true(code is not None, f"Invitation generated human code: {code}")

    # C. Domain mismatch rejection when security.enforce_domain_match is true
    bad_domain_email = f"invalid_{invite_uuid}@gmail.com"
    bad_domain_resp = requests.post(
        f"{API_BASE}/organizations/invitations",
        headers=sarah_headers,
        json={"email": bad_domain_email}
    )
    assert_true(bad_domain_resp.status_code == 400, "Invitation with unauthorized domain rejected (400)")

    print_header("3. NEW USER INVITATION REDEMPTION & ACCOUNT SETUP")

    # A. Verify invitation endpoint
    verify_resp = requests.post(f"{API_BASE}/onboarding/invitations/verify", json={"code": code})
    assert_true(verify_resp.status_code == 200, "Invitation verification succeeds")
    v_data = verify_resp.json()
    assert_true(v_data["valid"] is True, "Invitation is reported valid")
    assert_true(v_data["is_existing_user"] is False, "Recipient identified as non-existing user")
    assert_true(v_data["requires_password_setup"] is True, "Password setup required for new user")
    assert_true(v_data["organization_slug"] == "apex-univ", "Organization slug matches 'apex-univ'")

    # B. Redeem as new user -> returns onboarding token
    redeem_resp = requests.post(f"{API_BASE}/onboarding/invitations/redeem", json={"code": code})
    assert_true(redeem_resp.status_code == 200, "Invitation redeem succeeds for new user")
    r_data = redeem_resp.json()
    assert_true(r_data["requires_password_setup"] is True, "Redeem indicates password setup required")
    onboarding_token = r_data["onboarding_token"]
    assert_true(bool(onboarding_token), "Onboarding token returned")

    # C. Complete setup (password and username)
    new_username = f"apex_student_{invite_uuid}"
    setup_resp = requests.post(f"{API_BASE}/onboarding/invitations/complete-setup", json={
        "onboarding_token": onboarding_token,
        "username": new_username,
        "password": "SecurePassword123!"
    })
    assert_true(setup_resp.status_code == 200, "Complete setup succeeds")
    setup_data = setup_resp.json()
    assert_true(setup_data["status"] == "accepted", "Invitation status is accepted")
    assert_true("access_token" in setup_data, "Active session access token returned")

    # D. Verify database records: User is verified and membership created in Apex University
    user_db_id = run_sql(f"SELECT id FROM users WHERE username = '{new_username}';")
    assert_true(bool(user_db_id), f"User record created in database (ID {user_db_id})")
    
    is_verified = run_sql(f"SELECT is_verified FROM users WHERE id = {user_db_id};")
    assert_true(is_verified == "t", "User created via invitation is marked verified")

    apex_org_id = run_sql("SELECT id FROM organizations WHERE slug = 'apex-univ';")
    mem_exists = run_sql(f"""
        SELECT count(*) FROM organization_memberships 
        WHERE user_id = {user_db_id} AND organization_id = {apex_org_id} AND status = 'active';
    """)
    assert_true(int(mem_exists) == 1, "Active membership created in Apex University")

    # E. Double redemption attempt -> 409 Conflict
    double_redeem = requests.post(f"{API_BASE}/onboarding/invitations/redeem", json={"code": code})
    assert_true(double_redeem.status_code == 409, "Double redemption rejected with 409 Conflict")

    print_header("4. EXISTING USER ACCEPTS INVITATION & CROSS-ORG ISOLATION")

    # Scenario: User already exists on TLD with an existing membership.
    # We invite them to Apex University.
    exist_uuid = uuid.uuid4().hex[:6]
    exist_email = f"existing_{exist_uuid}@apex.edu"
    
    # 1. Register existing user directly on root platform
    reg_exist = requests.post(f"{API_BASE}/register", json={
        "email": exist_email,
        "username": f"exist_{exist_uuid}",
        "password": "Password123!"
    })
    assert_true(reg_exist.status_code in (200, 201), "Existing user registered")
    exist_user_id = run_sql(f"SELECT id FROM users WHERE email = '{exist_email}';")

    # 2. Sarah invites this existing user to Apex University
    exist_invite_resp = requests.post(
        f"{API_BASE}/organizations/invitations",
        headers=sarah_headers,
        json={"email": exist_email}
    )
    assert_true(exist_invite_resp.status_code == 200, "Invitation created for existing user")
    exist_code = exist_invite_resp.json()["invitation_code"]

    # 3. Security: Authenticated with WRONG user token -> must reject with 403 Forbidden!
    mismatch_resp = requests.post(
        f"{API_BASE}/onboarding/invitations/redeem",
        headers=learner_headers, # learner has a different email
        json={"code": exist_code}
    )
    assert_true(mismatch_resp.status_code == 403, "Authenticated user with mismatched email rejected (403 Forbidden)")

    # 4. Correct existing user accepts invitation
    exist_login = requests.post(f"{API_BASE}/login", json={"email": exist_email, "password": "Password123!"})
    exist_token = exist_login.json()["access_token"]
    
    exist_accept = requests.post(
        f"{API_BASE}/onboarding/invitations/redeem",
        headers={"Authorization": f"Bearer {exist_token}"},
        json={"code": exist_code}
    )
    assert_true(exist_accept.status_code == 200, "Existing user successfully redeems invitation")
    assert_true(exist_accept.json()["status"] == "accepted", "Status is accepted")
    assert_true(exist_accept.json()["requires_password_setup"] is False, "No password setup needed for existing user")

    # 5. Verify existing user account was REUSED (no duplicate user row created)
    user_count = run_sql(f"SELECT count(*) FROM users WHERE email = '{exist_email}';")
    assert_true(int(user_count) == 1, "Existing user account was reused without duplicates")

    # 6. Verify membership now exists in Apex University
    new_mem = run_sql(f"""
        SELECT count(*) FROM organization_memberships 
        WHERE user_id = {exist_user_id} AND organization_id = {apex_org_id} AND status = 'active';
    """)
    assert_true(int(new_mem) == 1, "Existing user gained active membership in Apex University")

    print_header("5. COHORT-SPECIFIC INVITATIONS")

    # 1. Fetch or create a cohort in Apex University
    cohorts_list = requests.get(f"{API_BASE}/organizations/apex-univ/cohorts", headers=sarah_headers).json()
    if cohorts_list:
        test_cohort_id = cohorts_list[0]["id"]
    else:
        now_iso = "2026-11-23T20:00:00Z"
        c_create = requests.post(f"{API_BASE}/organizations/apex-univ/cohorts", headers=sarah_headers, json={
            "name": f"Cohort {invite_uuid}",
            "starts_at": now_iso,
            "ends_at": "2027-01-01T00:00:00Z"
        }).json()
        test_cohort_id = c_create["id"]

    # 2. Sarah invites user directly into the cohort
    cohort_student_email = f"cohort_student_{uuid.uuid4().hex[:6]}@apex.edu"
    cohort_inv_resp = requests.post(
        f"{API_BASE}/organizations/cohorts/{test_cohort_id}/invitations",
        headers=sarah_headers,
        json={"email": cohort_student_email}
    )
    assert_true(cohort_inv_resp.status_code == 200, "Cohort invitation issued")
    c_code = cohort_inv_resp.json()["invitation_code"]

    # 3. Verify displays cohort name
    v_cohort = requests.post(f"{API_BASE}/onboarding/invitations/verify", json={"code": c_code}).json()
    assert_true(v_cohort["cohort_name"] is not None, f"Cohort name verified: {v_cohort['cohort_name']}")

    # 4. Redeem cohort invitation
    c_redeem = requests.post(f"{API_BASE}/onboarding/invitations/redeem", json={"code": c_code}).json()
    c_setup = requests.post(f"{API_BASE}/onboarding/invitations/complete-setup", json={
        "onboarding_token": c_redeem["onboarding_token"],
        "username": f"c_student_{uuid.uuid4().hex[:6]}",
        "password": "Password123!"
    })
    assert_true(c_setup.status_code == 200, "Cohort invitation setup completed")

    # 5. Check database: user has both org membership and cohort membership
    c_user_id = run_sql(f"SELECT id FROM users WHERE email = '{cohort_student_email}';")
    c_mem_id = run_sql(f"SELECT id FROM organization_memberships WHERE user_id = {c_user_id} AND organization_id = {apex_org_id};")
    cohort_mem_count = run_sql(f"""
        SELECT count(*) FROM cohort_memberships 
        WHERE cohort_id = {test_cohort_id} AND organization_membership_id = {c_mem_id};
    """)
    assert_true(int(cohort_mem_count) == 1, "User joined cohort upon invitation acceptance")

    print_header("6. INVITATION RESEND & REVOCATION LIFECYCLE")

    # 1. Create a fresh invitation to test resend and revoke
    life_email = f"lifecycle_{uuid.uuid4().hex[:6]}@apex.edu"
    life_resp = requests.post(f"{API_BASE}/organizations/invitations", headers=sarah_headers, json={"email": life_email}).json()
    life_id = life_resp["id"]
    old_code = life_resp["invitation_code"]

    # 2. Resend invitation
    resend_resp = requests.post(f"{API_BASE}/organizations/invitations/{life_id}/resend", headers=sarah_headers)
    assert_true(resend_resp.status_code == 200, "Resend invitation succeeds")
    new_code = resend_resp.json()["invitation_code"]
    assert_true(new_code != old_code, f"Resend generated fresh code (Old: {old_code}, New: {new_code})")

    # 3. Old code cannot be redeemed (token has been refreshed)
    old_code_redeem = requests.post(f"{API_BASE}/onboarding/invitations/redeem", json={"code": old_code})
    assert_true(old_code_redeem.status_code == 404, "Previous invitation code is invalidated by resend (404)")

    # 4. Revoke invitation
    revoke_resp = requests.post(f"{API_BASE}/organizations/invitations/{life_id}/revoke", headers=sarah_headers)
    assert_true(revoke_resp.status_code == 200, "Invitation successfully revoked")

    # 5. Revoked code cannot be redeemed -> 410 Gone
    revoked_redeem = requests.post(f"{API_BASE}/onboarding/invitations/redeem", json={"code": new_code})
    assert_true(revoked_redeem.status_code == 410, "Revoked invitation rejected with 410 Gone")

    print_header("7. BULK CSV INVITATIONS")

    # Prepare CSV with valid, duplicate, invalid email, and unknown cohort
    csv_content = f"""email,cohort
bulk_1_{uuid.uuid4().hex[:4]}@apex.edu,{test_cohort_id}
bulk_2_{uuid.uuid4().hex[:4]}@apex.edu,{test_cohort_id}
bulk_1_{uuid.uuid4().hex[:4]}@apex.edu,{test_cohort_id}
not_an_email,{test_cohort_id}
bulk_fail_{uuid.uuid4().hex[:4]}@apex.edu,999999
"""
    files = {"file": ("students.csv", csv_content, "text/csv")}
    bulk_resp = requests.post(
        f"{API_BASE}/organizations/invitations/bulk",
        headers=sarah_headers,
        files=files
    )
    assert_true(bulk_resp.status_code == 200, "Bulk CSV upload endpoint returns 200")
    b_data = bulk_resp.json()
    assert_true(b_data["created_count"] >= 2, f"Created invitations count: {b_data['created_count']}")
    assert_true(b_data["skipped_count"] >= 2, f"Skipped/error rows count: {b_data['skipped_count']}")
    
    # Check that invalid format row and unknown cohort row are clearly reported
    res_statuses = [r["status"] for r in b_data["results"]]
    assert_true("created" in res_statuses, "Bulk contains 'created' status")
    assert_true("invalid_format" in res_statuses, "Bulk contains 'invalid_format' status")
    assert_true("error" in res_statuses, "Bulk contains 'error' status for unknown cohort")

    print_header("8. DOMAIN ELIGIBILITY & ACCESS REQUEST WORKFLOW")

    # 1. Test subdomain info
    info_resp = requests.get(f"{API_BASE}/onboarding/organization-info", headers={"Host": "apex-univ.org.thelastdeploy.com"})
    assert_true(info_resp.status_code == 200, "Public organization info retrieved")
    assert_true("apex.edu" in info_resp.json()["domains"], "Organization verified domains include 'apex.edu'")

    # 2. Ineligible domain rejected
    bad_req = requests.post(
        f"{API_BASE}/onboarding/access-request",
        headers={"Host": "apex-univ.org.thelastdeploy.com"},
        json={"email": f"stranger_{uuid.uuid4().hex[:4]}@yahoo.com"}
    )
    assert_true(bad_req.status_code == 400, "Ineligible email domain rejected for access request (400)")

    # 3. Lookalike domain rejected (e.g. fakeapex.edu)
    lookalike_req = requests.post(
        f"{API_BASE}/onboarding/access-request",
        headers={"Host": "apex-univ.org.thelastdeploy.com"},
        json={"email": f"attacker_{uuid.uuid4().hex[:4]}@fakeapex.edu"}
    )
    assert_true(lookalike_req.status_code == 400, "Lookalike domain rejected (400)")

    # 4. Valid domain access request
    req_email = f"applicant_{uuid.uuid4().hex[:6]}@apex.edu"
    acc_req_resp = requests.post(
        f"{API_BASE}/onboarding/access-request",
        headers={"Host": "apex-univ.org.thelastdeploy.com"},
        json={"email": req_email}
    )
    assert_true(acc_req_resp.status_code == 200, "Eligible domain access request submitted")

    # 5. Admin lists access requests
    req_list = requests.get(f"{API_BASE}/organizations/access-requests", headers=sarah_headers).json()
    pending_for_email = [r for r in req_list if r["email"] == req_email]
    assert_true(len(pending_for_email) > 0 or acc_req_resp.json().get("mode") == "automatic", "Access request recorded")

    if pending_for_email:
        req_id = pending_for_email[0]["id"]
        # 6. Admin approves access request -> generates invitation
        appr_resp = requests.post(f"{API_BASE}/organizations/access-requests/{req_id}/approve", headers=sarah_headers)
        assert_true(appr_resp.status_code == 200, "Admin approves access request")
        assert_true(appr_resp.json()["status"] == "approved", "Status reported as approved")
        assert_true(bool(appr_resp.json()["invitation_id"]), "Invitation generated on approval")

    print_header("9. AUDIT LOGGING VERIFICATION")

    # Verify audit log recorded Module F events
    recent_events = run_sql("""
        SELECT action FROM audit_logs 
        WHERE entity_type IN ('organization_invitation', 'organization_access_request', 'organization')
        ORDER BY id DESC LIMIT 20;
    """)
    assert_true("invitation.created" in recent_events, "Audit log contains 'invitation.created'")
    assert_true("invitation.redeemed" in recent_events, "Audit log contains 'invitation.redeemed'")
    assert_true("invitation.revoked" in recent_events, "Audit log contains 'invitation.revoked'")
    assert_true("invitation.bulk_created" in recent_events, "Audit log contains 'invitation.bulk_created'")

    print("\n" + "="*70)
    print("🎉 ALL MODULE F TEST SUITE CHECKS PASSED PERFECTLY! 🎉")
    print("="*70 + "\n")

if __name__ == "__main__":
    main()
