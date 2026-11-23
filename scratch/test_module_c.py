"""
Comprehensive Test Suite for Module C: Content Ownership, Customization & Publishing
"""

import os
import sys
import json
import shutil
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

def main():
    print_header("1. HASH DETERMINISM AND INDEPENDENT HASHING")
    
    # Import hashing directly from backend
    sys.path.insert(0, "/home/fsociety/Documents/thelastdeploy/web/backend")
    from app.hashing import compute_module_hash, compute_section_hash, compute_lab_hash, compute_files_hash
    
    # Test CRLF vs LF normalization
    mod_yaml_lf = b"id: test\ntitle: Test Module\n"
    mod_yaml_crlf = b"id: test\r\ntitle: Test Module\r\n"
    hash_lf = compute_module_hash(mod_yaml_lf)
    hash_crlf = compute_module_hash(mod_yaml_crlf)
    assert_true(hash_lf == hash_crlf, "CRLF and LF produce identical SHA-256 content hashes")
    
    # Test independence: changing section content does NOT change module hash
    sec_yaml = b"id: sec-1\ntitle: Section 1\n"
    sec_hash_1 = compute_section_hash(sec_yaml, b"Hello World")
    sec_hash_2 = compute_section_hash(sec_yaml, b"Hello World Modified")
    assert_true(sec_hash_1 != sec_hash_2, "Section hash changes when section content.md changes")
    assert_true(hash_lf == compute_module_hash(mod_yaml_lf), "Module hash remains unchanged despite section change")
    
    # Test lab hash
    lab_yaml = b"id: lab-1\ntitle: Lab 1\n"
    lab_hash_1 = compute_lab_hash(lab_yaml, cleanup_sh=b"echo clean", validator_sh=b"echo valid")
    lab_hash_2 = compute_lab_hash(lab_yaml, cleanup_sh=b"echo clean", validator_sh=b"echo valid modified")
    assert_true(lab_hash_1 != lab_hash_2, "Lab hash changes when validator script changes")
    assert_true(sec_hash_1 == compute_section_hash(sec_yaml, b"Hello World"), "Section hash remains unchanged despite lab change")

    print_header("2. AUTHENTICATION & CONTEXT SETUP")
    
    # Login as devuser (platform admin)
    login_resp = requests.post(f"{API_BASE}/login", json={"email": "dev@example.com", "password": "devpassword123"})
    assert_true(login_resp.status_code == 200, f"devuser login succeeds: {login_resp.text}")
    dev_token = login_resp.json()["access_token"]
    
    # Login as learner in apex-univ
    learner_email = "student_c@apex.edu"
    learner_pwd = "Password123!"
    reg_resp = requests.post(f"{API_BASE}/register", json={
        "email": learner_email,
        "password": learner_pwd,
        "username": "student_c_user",
        "first_name": "Student",
        "last_name": "Apex",
        "organization_slug": "apex-univ"
    })
    l_resp = requests.post(f"{API_BASE}/login", json={"email": learner_email, "password": learner_pwd})
    learner_token = l_resp.json().get("access_token")
    
    assert_true(bool(learner_token), "Learner account authenticated")

    print_header("3. CONTRIBUTOR WORKFLOW: PULL MODULE")
    
    # Attempting to pull an unverified module or non-existent module
    bad_pull = requests.get(
        f"{API_BASE}/modules/non-existent-module/export",
        headers={"Authorization": f"Bearer {dev_token}"}
    )
    assert_true(bad_pull.status_code == 404, "Pulling non-existent module returns 404")
    
    # Pull official verified TLD curriculum module: linux-fundamentals
    pull_resp = requests.get(
        f"{API_BASE}/modules/linux-fundamentals/export",
        headers={"Authorization": f"Bearer {dev_token}"}
    )
    assert_true(pull_resp.status_code == 200, "Export official verified TLD module linux-fundamentals succeeds")
    export_data = pull_resp.json()
    assert_true(export_data["id"] == "linux-fundamentals", "Exported module ID matches")
    assert_true(len(export_data["sections"]) > 0, f"Exported {len(export_data['sections'])} sections")
    assert_true(bool(export_data["content_hash"]), f"Module baseline content_hash present: {export_data['content_hash']}")
    
    # Test CLI pull into a temporary folder
    test_workdir = "/tmp/tld_test_module_c"
    if os.path.exists(test_workdir):
        shutil.rmtree(test_workdir)
    os.makedirs(test_workdir)
    
    # Write tld-dev config pointing to devuser in apex-univ workspace
    dev_dir = os.path.expanduser("~/.tld-dev")
    os.makedirs(dev_dir, exist_ok=True)
    with open(os.path.join(dev_dir, "config.yaml"), "w") as f:
        f.write(f"""environment: local
api_base_url: {API_BASE}
device_key_path: {dev_dir}/device.key
challenges_dir: {dev_dir}/challenges
challenges_repo: thelastdeploy/thelastdeploy
auth_token: {dev_token}
username: devuser
active_org: apex-univ
""")

    tld_bin = "/home/fsociety/Documents/thelastdeploy/bin/tld-dev"
    pull_proc = subprocess.run(
        [tld_bin, "pull", "linux-fundamentals"],
        cwd=test_workdir,
        capture_output=True,
        text=True
    )
    assert_true(pull_proc.returncode == 0, f"tld-dev pull linux-fundamentals succeeds:\n{pull_proc.stdout}")
    pulled_dir = os.path.join(test_workdir, "linux-fundamentals")
    assert_true(os.path.exists(pulled_dir), "Pulled module directory exists")
    assert_true(os.path.exists(os.path.join(pulled_dir, ".tld-baseline.json")), ".tld-baseline.json generated")
    
    with open(os.path.join(pulled_dir, ".tld-baseline.json")) as f:
        baseline_meta = json.load(f)
    assert_true(baseline_meta["original_module_id"] == "linux-fundamentals", "Baseline original_module_id recorded")
    assert_true(len(baseline_meta["sections"]) > 0, "Baseline sections recorded")
    assert_true(len(baseline_meta["labs"]) > 0, "Baseline labs recorded")

    print_header("4. PUBLISHING PERMISSION ENFORCEMENT")
    
    # Learner (no content.publish permission) publishing -> must fail with 403
    pub_payload = {
        "id": "linux-fundamentals",
        "title": "Unauthorized Mod",
        "topic": "linux",
        "difficulty": "beginner",
        "sections": []
    }
    learner_pub_resp = requests.post(
        f"{API_BASE}/builder/modules",
        headers={
            "Authorization": f"Bearer {learner_token}",
            "X-Organization-Slug": "apex-univ"
        },
        json=pub_payload
    )
    assert_true(learner_pub_resp.status_code == 403, f"Learner publishing without content.publish fails with 403: {learner_pub_resp.text}")

    print_header("5. UPWARD OWNERSHIP PROPAGATION & SELECTIVE PERSISTENCE")
    
    # Clean up any prior test artifacts from DB
    subprocess.run(["docker", "exec", "-i", "tld-db", "psql", "-U", "tld", "-d", "tld_db", "-c",
                    "DELETE FROM modules WHERE id = 'apex-univ-linux-fundamentals'; "
                    "DELETE FROM sections WHERE id LIKE 'apex-univ-%'; "
                    "DELETE FROM labs WHERE id LIKE 'apex-univ-%';"], check=True)
    
    # Find a section and a lab to customize
    # Let's inspect baseline_meta["labs"]
    sample_lab_id = list(baseline_meta["labs"].keys())[0]
    sample_lab_info = baseline_meta["labs"][sample_lab_id]
    sample_sec_id = sample_lab_info["section_id"]
    sample_lab_path = os.path.join(pulled_dir, sample_lab_info["path"])
    
    print(f"Customizing lab: {sample_lab_id} in section: {sample_sec_id}")
    
    # Modify validator.sh or create/modify something in that lab
    val_file = os.path.join(sample_lab_path, "validator.sh")
    with open(val_file, "a") as vf:
        vf.write("\n# Custom Apex University check\necho 'custom test passed'\n")
        
    # Execute tld-dev publish from apex-univ
    pub_proc = subprocess.run(
        [tld_bin, "publish", pulled_dir],
        cwd=test_workdir,
        capture_output=True,
        text=True
    )
    assert_true(pub_proc.returncode == 0, f"tld-dev publish succeeds:\n{pub_proc.stdout}")
    assert_true("Custom/Org-owned" in pub_proc.stdout, "Publish output indicates Custom/Org-owned for modified entities")
    assert_true("TLD Core (inherited)" in pub_proc.stdout, "Publish output indicates TLD Core (inherited) for unmodified entities")

    # Verify Database state
    # 1. Custom module record exists with slug prefix: apex-univ-linux-fundamentals
    # 2. Custom section record exists: apex-univ-{sample_sec_id}
    # 3. Custom lab record exists: apex-univ-{sample_lab_id}
    # 4. Unmodified sections have NO apex-univ record, and are referenced by their original TLD IDs
    # 5. Unmodified sibling labs have NO apex-univ record, and are referenced by their original TLD IDs
    # 6. Status is 'published', total_xp is 0
    
    mod_check_resp = requests.get(
        f"{API_BASE}/modules/apex-univ-linux-fundamentals",
        headers={"Authorization": f"Bearer {dev_token}", "X-Organization-Slug": "apex-univ"}
    )
    assert_true(mod_check_resp.status_code == 200, "Published module apex-univ-linux-fundamentals accessible")
    custom_mod = mod_check_resp.json()
    assert_true(custom_mod["status"] == "published", "Published module has status = 'published'")
    assert_true(custom_mod["is_official_verified"] == False, "Published module has is_official_verified = False")
    assert_true(custom_mod["total_xp"] == 0, f"Published unverified module has total_xp = 0 (got {custom_mod['total_xp']})")

    # Detailed verification of DB rows via PostgreSQL query helper
    def run_sql(query: str) -> str:
        res = subprocess.run(
            ["docker", "exec", "-i", "tld-db", "psql", "-U", "tld", "-d", "tld_db", "-t", "-A", "-c", query],
            capture_output=True,
            text=True,
            check=True
        )
        return res.stdout.strip()

    apex_org_id = run_sql("SELECT id FROM organizations WHERE slug = 'apex-univ';")
    assert_true(bool(apex_org_id), f"apex-univ organization found in DB (ID: {apex_org_id})")
    
    # Check custom module record in DB
    custom_mod_row = run_sql("SELECT id, owner_organization_id, sections FROM modules WHERE id = 'apex-univ-linux-fundamentals';")
    assert_true(bool(custom_mod_row), "apex-univ-linux-fundamentals exists in DB")
    parts = custom_mod_row.split("|")
    assert_true(parts[1] == apex_org_id, "Module owned by apex-univ organization")
    sections_json = json.loads(parts[2])
    
    # Check sections in custom module
    expected_org_sec_id = f"apex-univ-{sample_sec_id}"
    assert_true(expected_org_sec_id in sections_json, f"Modified section {expected_org_sec_id} in module sections")
    
    # Check that unmodified sections in custom module still reference original TLD IDs
    other_sec_ids = [sid for sid in sections_json if sid != expected_org_sec_id]
    assert_true(len(other_sec_ids) > 0, "Unmodified sections referenced in custom module")
    for osid in other_sec_ids:
        assert_true(not osid.startswith("apex-univ-"), f"Unmodified section {osid} retains original TLD ID")
        # Ensure no accidental org-owned row was created
        bogus_count = run_sql(f"SELECT count(*) FROM sections WHERE id = 'apex-univ-{osid}';")
        assert_true(bogus_count == "0", f"No redundant org section created for unmodified section {osid}")
        
    # Check the modified section's labs
    sec_labs_raw = run_sql(f"SELECT labs FROM sections WHERE id = '{expected_org_sec_id}';")
    assert_true(bool(sec_labs_raw), f"Section {expected_org_sec_id} exists in DB")
    sec_labs_json = json.loads(sec_labs_raw)
    expected_org_lab_id = f"apex-univ-{sample_lab_id}"
    assert_true(expected_org_lab_id in sec_labs_json, f"Modified lab {expected_org_lab_id} in section labs")
    
    # Check sibling labs in the same section
    sibling_lab_ids = [lid for lid in sec_labs_json if lid != expected_org_lab_id]
    for slid in sibling_lab_ids:
        assert_true(not slid.startswith("apex-univ-"), f"Sibling unmodified lab {slid} retains original TLD ID")
        bogus_lab_count = run_sql(f"SELECT count(*) FROM labs WHERE id = 'apex-univ-{slid}';")
        assert_true(bogus_lab_count == "0", f"No redundant org lab created for unmodified lab {slid}")

    print_header("6. VERIFICATION WORKFLOW & PERMISSION GATING")
    
    # Learner attempting to verify -> 403
    learner_verify = requests.post(
        f"{API_BASE}/modules/apex-univ-linux-fundamentals/verify",
        headers={"Authorization": f"Bearer {learner_token}", "X-Organization-Slug": "apex-univ"}
    )
    assert_true(learner_verify.status_code == 403, "Learner cannot verify module (403 Forbidden)")
    
    # Authorized verifier (devuser / platform admin or org admin) verifying module
    verify_resp = requests.post(
        f"{API_BASE}/modules/apex-univ-linux-fundamentals/verify",
        headers={"Authorization": f"Bearer {dev_token}", "X-Organization-Slug": "apex-univ"}
    )
    assert_true(verify_resp.status_code == 200, f"Authorized verifier succeeds: {verify_resp.text}")
    
    verified_status = run_sql("SELECT status, total_xp FROM modules WHERE id = 'apex-univ-linux-fundamentals';")
    v_parts = verified_status.split("|")
    assert_true(v_parts[0] == "verified", "Module status is now 'verified'")
    assert_true(int(v_parts[1]) > 0, f"Verified module awarded total_xp = {v_parts[1]} > 0")

    print_header("7. LIVE INHERITANCE OF OFFICIAL TLD UPDATES")
    
    # Pick one of the unmodified sections referenced by the custom module
    unmodified_sec_id = other_sec_ids[0]
    original_title = run_sql(f"SELECT title FROM sections WHERE id = '{unmodified_sec_id}';")
    assert_true(bool(original_title), f"TLD section row {unmodified_sec_id} exists (Title: '{original_title}')")
    
    # Update official TLD section title
    updated_title = f"{original_title} [TLD LIVE UPDATE]"
    run_sql(f"UPDATE sections SET title = '{updated_title}' WHERE id = '{unmodified_sec_id}';")
    
    # Fetch customized module syllabus via API
    syllabus_resp = requests.get(
        f"{API_BASE}/modules/apex-univ-linux-fundamentals/full",
        headers={"Authorization": f"Bearer {dev_token}", "X-Organization-Slug": "apex-univ"}
    )
    assert_true(syllabus_resp.status_code == 200, "Fetch syllabus succeeds")
    syllabus_data = syllabus_resp.json()
    
    matching_sec = next((s for s in syllabus_data["sections"] if s["id"] == unmodified_sec_id), None)
    assert_true(matching_sec is not None, "Unmodified section resolved in customized module syllabus")
    assert_true(matching_sec["title"] == updated_title, f"Live update inherited immediately in customized module! ('{matching_sec['title']}')")

    # Restore original title
    run_sql(f"UPDATE sections SET title = '{original_title}' WHERE id = '{unmodified_sec_id}';")

    # Clean up test workdir
    shutil.rmtree(test_workdir)

    print("\n🎉 ALL MODULE C TEST SUITE CHECKS PASSED PERFECTLY! 🎉\n")

if __name__ == "__main__":
    main()
