"""
Comprehensive Test Suite for Module D: Progress Tracking & XP Management
"""

import os
import sys
import json
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
    print_header("1. DATA MODEL INTEGRITY CONSTRAINTS")
    
    # Verify no disallowed tables or columns exist
    tables = run_sql("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';").split("\n")
    assert_true("module_progress" not in tables, "No 'module_progress' table exists")
    assert_true("xp_transactions" not in tables, "No 'xp_transactions' table exists")
    assert_true("lab_attempts" not in tables, "No 'lab_attempts' table exists")
    assert_true("retry_history" not in tables, "No 'retry_history' table exists")
    
    lab_prog_cols = run_sql("SELECT column_name FROM information_schema.columns WHERE table_name = 'lab_progress';").split("\n")
    assert_true("xp_status" not in lab_prog_cols, "No 'xp_status' column in 'lab_progress'")
    assert_true("xp_awarded" in lab_prog_cols, "'xp_awarded' snapshot column exists in 'lab_progress'")
    
    sec_prog_cols = run_sql("SELECT column_name FROM information_schema.columns WHERE table_name = 'section_progress';").split("\n")
    assert_true("xp_status" not in sec_prog_cols, "No 'xp_status' column in 'section_progress'")
    assert_true("xp_awarded" in sec_prog_cols, "'xp_awarded' snapshot column exists in 'section_progress'")

    print_header("2. USER & MULTI-ORGANIZATION MEMBERSHIP SETUP")
    
    # Login as platform devuser
    login_resp = requests.post(f"{API_BASE}/login", json={"email": "dev@example.com", "password": "devpassword123"})
    assert_true(login_resp.status_code == 200, "devuser login succeeds")
    dev_token = login_resp.json()["access_token"]
    
    # Create a fresh multi-org test learner
    unique_id = uuid.uuid4().hex[:8]
    learner_email = f"learner_{unique_id}@test.com"
    learner_pwd = "Password123!"
    
    reg_resp = requests.post(f"{API_BASE}/register", json={
        "email": learner_email,
        "password": learner_pwd,
        "username": f"user_{unique_id}",
        "first_name": "Test",
        "last_name": "Learner",
        "organization_slug": "tld"
    })
    assert_true(reg_resp.status_code in (200, 201), "Learner registration succeeds")
    
    l_login = requests.post(f"{API_BASE}/login", json={"email": learner_email, "password": learner_pwd})
    assert_true(l_login.status_code == 200, "Learner login succeeds")
    learner_token = l_login.json()["access_token"]
    
    user_id = run_sql(f"SELECT id FROM users WHERE email = '{learner_email}';")
    assert_true(bool(user_id), f"Learner user ID resolved: {user_id}")
    
    # Fetch org IDs
    tld_org_id = run_sql("SELECT id FROM organizations WHERE slug = 'tld';")
    apex_org_id = run_sql("SELECT id FROM organizations WHERE slug = 'apex-univ';")
    cloudscale_org_id = run_sql("SELECT id FROM organizations WHERE slug = 'cloudscale';")
    
    # Ensure learner has active memberships in Org A (tld), Org B (apex-univ), and Org C (cloudscale)
    for oid in [tld_org_id, apex_org_id, cloudscale_org_id]:
        mem_exists = run_sql(f"SELECT id FROM organization_memberships WHERE user_id = {user_id} AND organization_id = {oid} AND status = 'active';")
        if not mem_exists:
            run_sql(f"INSERT INTO organization_memberships (user_id, organization_id, status, total_xp, unverified_xp) VALUES ({user_id}, {oid}, 'active', 0, 0);")
            
    tld_mem_id = run_sql(f"SELECT id FROM organization_memberships WHERE user_id = {user_id} AND organization_id = {tld_org_id};")
    apex_mem_id = run_sql(f"SELECT id FROM organization_memberships WHERE user_id = {user_id} AND organization_id = {apex_org_id};")
    cloud_mem_id = run_sql(f"SELECT id FROM organization_memberships WHERE user_id = {user_id} AND organization_id = {cloudscale_org_id};")
    
    assert_true(bool(tld_mem_id) and bool(apex_mem_id) and bool(cloud_mem_id), "Active memberships verified across all 3 test organizations")

    print_header("3. LAB COMPLETION & LOCAL-FIRST VALIDATION")
    
    # 3.1 Failed lab check must NOT record completion and must NOT award XP
    target_lab = "lnx-open-terminal"
    lab_xp = int(run_sql(f"SELECT xp FROM labs WHERE id = '{target_lab}';"))
    val_hash = run_sql(f"SELECT validator_hash FROM labs WHERE id = '{target_lab}';")
    assert_true(lab_xp > 0, f"Target lab '{target_lab}' has {lab_xp} XP")
    
    fail_res = requests.post(f"{API_BASE}/results", headers={
        "Authorization": f"Bearer {learner_token}",
        "X-Organization-Slug": "apex-univ"
    }, json={
        "lab_id": target_lab,
        "section_id": "02-terminal-basics",
        "passed": False,
        "validator_hash": val_hash,
        "output": "command not found: bash test failed"
    })
    assert_true(fail_res.status_code == 200, f"POST /results with passed=False succeeds: {fail_res.text}")
    assert_true(fail_res.json()["xp_awarded"] == 0, "Failed lab check awards 0 XP")
    
    # Verify no LabProgress record created
    prog_count = run_sql(f"SELECT count(*) FROM lab_progress WHERE lab_id = '{target_lab}' AND organization_membership_id IN ({tld_mem_id}, {apex_mem_id}, {cloud_mem_id});")
    assert_true(prog_count == "0", "No LabProgress created on failed check")
    
    # 3.2 Successful lab check
    pass_res = requests.post(f"{API_BASE}/results", headers={
        "Authorization": f"Bearer {learner_token}",
        "X-Organization-Slug": "apex-univ"
    }, json={
        "lab_id": target_lab,
        "section_id": "02-terminal-basics",
        "passed": True,
        "validator_hash": val_hash,
        "output": "All tests passed successfully!"
    })
    assert_true(pass_res.status_code == 200, f"POST /results with passed=True succeeds: {pass_res.text}")
    assert_true(pass_res.json()["xp_awarded"] == lab_xp, f"Successful lab check awards {lab_xp} XP")

    print_header("4. CROSS-ORGANIZATION PROGRESS PROPAGATION")
    
    # lnx-open-terminal is an official TLD lab used by TLD platform and by Apex University via DevOps Foundations
    # CloudScale does NOT use linux-fundamentals
    tld_prog = run_sql(f"SELECT count(*) FROM lab_progress WHERE lab_id = '{target_lab}' AND organization_membership_id = {tld_mem_id};")
    apex_prog = run_sql(f"SELECT count(*) FROM lab_progress WHERE lab_id = '{target_lab}' AND organization_membership_id = {apex_mem_id};")
    cloud_prog = run_sql(f"SELECT count(*) FROM lab_progress WHERE lab_id = '{target_lab}' AND organization_membership_id = {cloud_mem_id};")
    
    assert_true(tld_prog == "1", "Progress propagated to TLD platform membership (content owner/user)")
    assert_true(apex_prog == "1", "Progress propagated to Apex University membership (uses content in Learning Path)")
    assert_true(cloud_prog == "0", "Progress DID NOT propagate to CloudScale (does not use content entity)")

    print_header("5. IDEMPOTENCY OF LAB COMPLETION")
    
    # Submitting the same completion again
    retry_res = requests.post(f"{API_BASE}/results", headers={
        "Authorization": f"Bearer {learner_token}",
        "X-Organization-Slug": "apex-univ"
    }, json={
        "lab_id": target_lab,
        "section_id": "02-terminal-basics",
        "passed": True,
        "validator_hash": val_hash,
        "output": "All tests passed successfully!"
    })
    assert_true(retry_res.status_code == 200, "Repeated submission succeeds")
    assert_true(retry_res.json()["xp_awarded"] == 0, "Repeated submission awards 0 XP (idempotent)")
    
    tld_prog_after = run_sql(f"SELECT count(*) FROM lab_progress WHERE lab_id = '{target_lab}' AND organization_membership_id = {tld_mem_id};")
    assert_true(tld_prog_after == "1", "No duplicate LabProgress record created on repeated submission")

    print_header("6. SECTION COMPLETION WORKFLOW")
    
    # Section 02-terminal-basics has 2 labs: lnx-open-terminal, lnx-run-first-command
    sec_id = "02-terminal-basics"
    sec_xp = int(run_sql(f"SELECT xp FROM sections WHERE id = '{sec_id}';"))
    
    # 6.1 Completing section before completing all required labs must fail with 400
    sec_fail_res = requests.post(f"{API_BASE}/modules/linux-fundamentals/sections/{sec_id}/complete", headers={
        "Authorization": f"Bearer {learner_token}",
        "X-Organization-Slug": "apex-univ"
    })
    assert_true(sec_fail_res.status_code == 400, f"Section completion rejected when required labs incomplete (400 Bad Request): {sec_fail_res.text}")
    
    # Complete the second required lab
    second_lab = "lnx-run-first-command"
    second_xp = int(run_sql(f"SELECT xp FROM labs WHERE id = '{second_lab}';"))
    second_val_hash = run_sql(f"SELECT validator_hash FROM labs WHERE id = '{second_lab}';")
    p2 = requests.post(f"{API_BASE}/results", headers={
        "Authorization": f"Bearer {learner_token}",
        "X-Organization-Slug": "apex-univ"
    }, json={
        "lab_id": second_lab,
        "section_id": sec_id,
        "passed": True,
        "validator_hash": second_val_hash,
        "output": "All tests passed!"
    })
    assert_true(p2.status_code == 200 and p2.json()["xp_awarded"] == second_xp, "Second required lab completed")
    
    # 6.2 Completing all labs does NOT automatically complete the section
    sec_prog_check = run_sql(f"SELECT count(*) FROM section_progress WHERE section_id = '{sec_id}' AND organization_membership_id = {apex_mem_id};")
    assert_true(sec_prog_check == "0", "Section is NOT automatically marked completed merely because all labs are done")
    
    # 6.3 Explicit website section completion trigger
    sec_pass_res = requests.post(f"{API_BASE}/modules/linux-fundamentals/sections/{sec_id}/complete", headers={
        "Authorization": f"Bearer {learner_token}",
        "X-Organization-Slug": "apex-univ"
    })
    assert_true(sec_pass_res.status_code == 200, "Explicit section completion succeeds")
    assert_true(sec_pass_res.json()["xp_awarded"] == sec_xp, f"Section completion awards {sec_xp} reading XP")
    
    # Verify section completion propagation: TLD (yes), Apex (yes), CloudScale (no)
    tld_s_prog = run_sql(f"SELECT count(*) FROM section_progress WHERE section_id = '{sec_id}' AND organization_membership_id = {tld_mem_id};")
    apex_s_prog = run_sql(f"SELECT count(*) FROM section_progress WHERE section_id = '{sec_id}' AND organization_membership_id = {apex_mem_id};")
    cloud_s_prog = run_sql(f"SELECT count(*) FROM section_progress WHERE section_id = '{sec_id}' AND organization_membership_id = {cloud_mem_id};")
    assert_true(tld_s_prog == "1", "Section progress propagated to TLD platform")
    assert_true(apex_s_prog == "1", "Section progress propagated to Apex University")
    assert_true(cloud_s_prog == "0", "Section progress DID NOT propagate to CloudScale")
    
    # 6.4 Section completion idempotency
    sec_retry_res = requests.post(f"{API_BASE}/modules/linux-fundamentals/sections/{sec_id}/complete", headers={
        "Authorization": f"Bearer {learner_token}",
        "X-Organization-Slug": "apex-univ"
    })
    assert_true(sec_retry_res.status_code == 200, "Repeated section completion request succeeds")
    assert_true(sec_retry_res.json()["xp_awarded"] == 0, "Repeated section completion awards 0 XP")

    print_header("7. XP SNAPSHOT AT COMPLETION")
    
    # Verify xp_awarded in lab_progress matches lab XP at time of completion
    saved_lab_xp = int(run_sql(f"SELECT xp_awarded FROM lab_progress WHERE lab_id = '{target_lab}' AND organization_membership_id = {apex_mem_id};"))
    assert_true(saved_lab_xp == lab_xp, f"Saved lab XP snapshot ({saved_lab_xp}) matches original lab XP ({lab_xp})")
    
    # Simulate content owner changing lab XP in the future
    run_sql(f"UPDATE labs SET xp = 999 WHERE id = '{target_lab}';")
    
    # Previously awarded XP must NOT change
    unchanged_lab_xp = int(run_sql(f"SELECT xp_awarded FROM lab_progress WHERE lab_id = '{target_lab}' AND organization_membership_id = {apex_mem_id};"))
    assert_true(unchanged_lab_xp == lab_xp, "Previously awarded XP was not rewritten by content XP change")
    
    # Restore original lab XP
    run_sql(f"UPDATE labs SET xp = {lab_xp} WHERE id = '{target_lab}';")

    print_header("8. VERIFIED VS UNVERIFIED XP & MODULE VERIFICATION TRANSFER")
    
    # Check current verified and unverified XP for Apex membership
    apex_xp_row = run_sql(f"SELECT total_xp, unverified_xp FROM organization_memberships WHERE id = {apex_mem_id};").split("|")
    apex_tot_before = int(apex_xp_row[0])
    apex_unv_before = int(apex_xp_row[1])
    print(f"Before custom unverified lab: Apex Total XP={apex_tot_before}, Unverified XP={apex_unv_before}")
    assert_true(apex_tot_before > 0, "Verified content added to total_xp")
    assert_true(apex_unv_before == 0, "No unverified XP yet")
    
    # Create an unverified module + lab in Apex University
    unv_mod_id = f"test-unv-mod-{unique_id}"
    unv_sec_id = f"test-unv-sec-{unique_id}"
    unv_lab_id = f"test-unv-lab-{unique_id}"
    
    run_sql(f"INSERT INTO modules (id, owner_organization_id, title, topic, difficulty, version, total_xp, sections, status) "
            f"VALUES ('{unv_mod_id}', {apex_org_id}, 'Unverified Custom Module', 'devops', 'intermediate', 1, 0, '[\"{unv_sec_id}\"]', 'published');")
    run_sql(f"INSERT INTO sections (id, owner_organization_id, title, xp, labs, version) "
            f"VALUES ('{unv_sec_id}', {apex_org_id}, 'Custom Unverified Section', 10, '[\"{unv_lab_id}\"]', 1);")
    run_sql(f"INSERT INTO labs (id, owner_organization_id, title, xp, version) "
            f"VALUES ('{unv_lab_id}', {apex_org_id}, 'Custom Unverified Lab', 50, 1);")
            
    # Learner completes the unverified lab
    unv_pass = requests.post(f"{API_BASE}/results", headers={
        "Authorization": f"Bearer {learner_token}",
        "X-Organization-Slug": "apex-univ"
    }, json={
        "lab_id": unv_lab_id,
        "section_id": unv_sec_id,
        "passed": True,
        "output": "Custom lab check passed"
    })
    assert_true(unv_pass.status_code == 200, "Unverified lab completed successfully")
    
    # Check XP: 50 XP should be added to unverified_xp, total_xp unchanged!
    apex_xp_mid = run_sql(f"SELECT total_xp, unverified_xp FROM organization_memberships WHERE id = {apex_mem_id};").split("|")
    apex_tot_mid = int(apex_xp_mid[0])
    apex_unv_mid = int(apex_xp_mid[1])
    print(f"After unverified lab: Apex Total XP={apex_tot_mid}, Unverified XP={apex_unv_mid}")
    assert_true(apex_tot_mid == apex_tot_before, "total_xp did NOT increase from unverified lab completion")
    assert_true(apex_unv_mid == 50, f"unverified_xp increased by 50 (got {apex_unv_mid})")
    
    # Now an authorized verifier approves the unverified module via verify_module
    verify_resp = requests.post(f"{API_BASE}/modules/{unv_mod_id}/verify", headers={
        "Authorization": f"Bearer {dev_token}",
        "X-Organization-Slug": "apex-univ"
    })
    assert_true(verify_resp.status_code == 200, f"Module verified by authorized reviewer: {verify_resp.text}")
    
    # Check XP after verification: 50 unverified XP must transfer to total_xp!
    apex_xp_after = run_sql(f"SELECT total_xp, unverified_xp FROM organization_memberships WHERE id = {apex_mem_id};").split("|")
    apex_tot_after = int(apex_xp_after[0])
    apex_unv_after = int(apex_xp_after[1])
    print(f"After verification: Apex Total XP={apex_tot_after}, Unverified XP={apex_unv_after}")
    assert_true(apex_unv_after == 0, f"unverified_xp was reduced to 0 (got {apex_unv_after})")
    assert_true(apex_tot_after == apex_tot_before + 50, f"total_xp increased by exactly 50 (from {apex_tot_before} to {apex_tot_after})")
    
    # Repeated approval call must be idempotent
    verify_again = requests.post(f"{API_BASE}/modules/{unv_mod_id}/verify", headers={
        "Authorization": f"Bearer {dev_token}",
        "X-Organization-Slug": "apex-univ"
    })
    assert_true(verify_again.status_code == 200, "Repeated verification request succeeds")
    apex_xp_idem = run_sql(f"SELECT total_xp, unverified_xp FROM organization_memberships WHERE id = {apex_mem_id};").split("|")
    assert_true(int(apex_xp_idem[0]) == apex_tot_after, "Repeated verification did NOT transfer XP twice (idempotent)")
    assert_true(int(apex_xp_idem[1]) == 0, "unverified_xp remains 0")

    print("\n🎉 ALL MODULE D TEST SUITE CHECKS PASSED PERFECTLY! 🎉\n")

if __name__ == "__main__":
    main()
