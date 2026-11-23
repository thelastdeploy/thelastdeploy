"""
Comprehensive Test Suite for Module E: Organization Settings & Configuration
Verifying Registry, Provisioning, Stability, Enablement/Disablement, Org Admin, Platform Admin, Effective Config, and Compatibility.
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
    print_header("1. REGISTRY INTEGRITY & VALIDATION CONSTRAINTS")
    
    # 1. Login platform admin devuser
    login_dev = requests.post(f"{API_BASE}/login", json={"email": "dev@example.com", "password": "devpassword123"})
    assert_true(login_dev.status_code == 200, "Platform devuser login succeeds")
    dev_token = login_dev.json()["access_token"]
    dev_headers = {"Authorization": f"Bearer {dev_token}"}
    
    # 2. Login apex org admin sarah
    login_sarah = requests.post(f"{API_BASE}/login", json={"email": "sarah.apex@example.com", "password": "Password123!"})
    assert_true(login_sarah.status_code == 200, "Apex org admin login succeeds")
    sarah_token = login_sarah.json()["access_token"]
    sarah_headers = {"Authorization": f"Bearer {sarah_token}", "X-Organization-Slug": "apex-univ"}

    # 3. Code-defined settings available via admin endpoint
    admin_settings = requests.get(f"{API_BASE}/admin/organizations/apex-univ/settings", headers=dev_headers)
    assert_true(admin_settings.status_code == 200, "Platform staff can list all registry settings")
    settings_data = admin_settings.json()
    keys = [s["key"] for s in settings_data]
    assert_true("content.show_unverified" in keys, "'content.show_unverified' is present in registry")
    assert_true("cohorts.max_active_cohorts" in keys, "'cohorts.max_active_cohorts' is present in registry")
    assert_true("learning_paths.default_visibility" in keys, "'learning_paths.default_visibility' is present in registry")

    # 4. Unsupported setting key rejected
    bad_key = "unsupported.custom.setting"
    res_bad_get = requests.get(f"{API_BASE}/organizations/apex-univ/settings/{bad_key}", headers=sarah_headers)
    assert_true(res_bad_get.status_code == 404, "Org admin GET for unsupported key returns 404")

    res_bad_patch = requests.patch(
        f"{API_BASE}/organizations/apex-univ/settings/{bad_key}",
        headers=sarah_headers,
        json={"value": True}
    )
    assert_true(res_bad_patch.status_code == 404, "Org admin PATCH for unsupported key returns 404")

    # 5. Type and constraint validation enforced
    # A. Boolean setting given non-boolean (string or int)
    res_type_err = requests.patch(
        f"{API_BASE}/organizations/apex-univ/settings/security.enforce_domain_match",
        headers=sarah_headers,
        json={"value": "not_a_bool"}
    )
    assert_true(res_type_err.status_code == 400, "Boolean setting rejects string value (400)")

    # B. Integer setting given out-of-range value (min is 1, max is 500)
    res_range_min = requests.patch(
        f"{API_BASE}/organizations/apex-univ/settings/cohorts.max_active_cohorts",
        headers=sarah_headers,
        json={"value": 0}
    )
    assert_true(res_range_min.status_code == 400, "Integer setting rejects value below min_value (400)")

    res_range_max = requests.patch(
        f"{API_BASE}/organizations/apex-univ/settings/cohorts.max_active_cohorts",
        headers=sarah_headers,
        json={"value": 9999}
    )
    assert_true(res_range_max.status_code == 400, "Integer setting rejects value above max_value (400)")

    # C. String setting with allowed_values constraints
    res_choice_err = requests.patch(
        f"{API_BASE}/organizations/apex-univ/settings/learning_paths.default_visibility",
        headers=sarah_headers,
        json={"value": "unlisted"}
    )
    assert_true(res_choice_err.status_code == 400, "String setting rejects value not in allowed_values (400)")

    print_header("2. NEW ORGANIZATION PROVISIONING WORKFLOW")
    
    unique_slug = f"test-org-{uuid.uuid4().hex[:6]}"
    prov_resp = requests.post(
        f"{API_BASE}/organizations",
        headers=dev_headers,
        json={
            "name": f"Test Org {unique_slug}",
            "slug": unique_slug,
            "type": "university",
            "domains": [f"{unique_slug}.edu"]
        }
    )
    assert_true(prov_resp.status_code == 201, f"Platform admin provisions new org '{unique_slug}'")
    test_org_id = prov_resp.json()["id"]

    # Verify initial settings provisioned
    org_settings_admin = requests.get(f"{API_BASE}/admin/organizations/{unique_slug}/settings", headers=dev_headers).json()
    assert_true(len(org_settings_admin) >= 9, "Newly provisioned org has all registry settings available to inspect")
    
    # Check default availability: content.show_unverified is enabled, content.allow_custom_modules is disabled in free tier
    unv_setting = next(s for s in org_settings_admin if s["key"] == "content.show_unverified")
    assert_true(unv_setting["is_enabled"] is True, "Default-eligible setting is initialized as enabled")

    custom_mod_setting = next(s for s in org_settings_admin if s["key"] == "content.allow_custom_modules")
    assert_true(custom_mod_setting["is_enabled"] is False, "Non-default setting is initialized as disabled")

    # Verify no duplicate configuration records
    dup_count = run_sql(f"""
        SELECT count(*) FROM (
            SELECT setting_key, count(*) 
            FROM organization_setting_availability 
            WHERE organization_id = {test_org_id} 
            GROUP BY setting_key 
            HAVING count(*) > 1
        ) sub;
    """)
    assert_true(int(dup_count) == 0, "No duplicate availability records created")

    print_header("3. EXISTING ORGANIZATIONS STABILITY & NON-INTERFERENCE")

    # Verify Apex Univ has its expected configuration
    apex_settings_before = requests.get(f"{API_BASE}/admin/organizations/apex-univ/settings", headers=dev_headers).json()
    apex_max_cohorts_before = next(s for s in apex_settings_before if s["key"] == "cohorts.max_active_cohorts")["value"]
    assert_true(apex_max_cohorts_before is not None, f"Apex currently has custom max_active_cohorts = {apex_max_cohorts_before}")

    # Explicitly test that changing a setting in test-org does not affect Apex
    patch_test_org = requests.patch(
        f"{API_BASE}/admin/organizations/{unique_slug}/settings/cohorts.max_active_cohorts",
        headers=dev_headers,
        json={"value": 42}
    )
    assert_true(patch_test_org.status_code == 200, "Updated max_active_cohorts in test org")

    apex_settings_after = requests.get(f"{API_BASE}/admin/organizations/apex-univ/settings", headers=dev_headers).json()
    apex_max_cohorts_after = next(s for s in apex_settings_after if s["key"] == "cohorts.max_active_cohorts")["value"]
    assert_true(apex_max_cohorts_after == apex_max_cohorts_before, "Apex configuration was not modified by test org changes")

    print_header("4. ENABLEMENT, DISABLEMENT & VALUE PRESERVATION")

    # Step 1: Platform enables content.allow_custom_modules for test org
    en_resp = requests.post(f"{API_BASE}/admin/organizations/{unique_slug}/settings/content.allow_custom_modules/enable", headers=dev_headers)
    assert_true(en_resp.status_code == 200, "Platform enables content.allow_custom_modules")
    assert_true(en_resp.json()["is_enabled"] is True, "Setting is reported as enabled")

    # Step 2: Platform overrides value to True
    val_resp = requests.patch(
        f"{API_BASE}/admin/organizations/{unique_slug}/settings/content.allow_custom_modules",
        headers=dev_headers,
        json={"value": True}
    )
    assert_true(val_resp.status_code == 200, "Platform sets custom value = True")
    assert_true(val_resp.json()["value"] is True, "Setting value updated to True")

    # Step 3: Platform disables content.allow_custom_modules
    dis_resp = requests.post(f"{API_BASE}/admin/organizations/{unique_slug}/settings/content.allow_custom_modules/disable", headers=dev_headers)
    assert_true(dis_resp.status_code == 200, "Platform disables content.allow_custom_modules")
    assert_true(dis_resp.json()["is_enabled"] is False, "Setting is reported as disabled")

    # Step 4: Verify DB preserved value True while disabled
    db_val = run_sql(f"""
        SELECT value FROM organization_settings 
        WHERE organization_id = {test_org_id} AND setting_key = 'content.allow_custom_modules';
    """)
    assert_true(db_val == "true", "Stored value True was preserved in DB across disablement")

    # Step 5: Re-enable setting without specifying initial_value
    re_en_resp = requests.post(f"{API_BASE}/admin/organizations/{unique_slug}/settings/content.allow_custom_modules/enable", headers=dev_headers)
    assert_true(re_en_resp.status_code == 200, "Platform re-enables content.allow_custom_modules")
    assert_true(re_en_resp.json()["is_enabled"] is True, "Setting is reported as enabled again")
    assert_true(re_en_resp.json()["value"] is True, "Previously configured value True is restored upon re-enabling")

    # Step 6: Verify boolean False is not confused with disabled state
    val_false_resp = requests.patch(
        f"{API_BASE}/admin/organizations/{unique_slug}/settings/content.allow_custom_modules",
        headers=dev_headers,
        json={"value": False}
    )
    assert_true(val_false_resp.status_code == 200, "Setting value explicitly set to False")
    assert_true(val_false_resp.json()["is_enabled"] is True, "Setting remains enabled even when value is False")
    assert_true(val_false_resp.json()["value"] is False, "Value is False")

    print_header("5. ORGANIZATION ADMINISTRATOR PRIVILEGES & ISOLATION")

    # 1. Sarah lists Apex settings (only enabled settings returned)
    sarah_list = requests.get(f"{API_BASE}/organizations/apex-univ/settings", headers=sarah_headers)
    assert_true(sarah_list.status_code == 200, "Sarah lists Apex University enabled settings")
    sarah_keys = [s["key"] for s in sarah_list.json()]
    assert_true("cohorts.max_active_cohorts" in sarah_keys, "Enabled setting visible to Org Admin")

    # 2. Sarah updates cohorts.max_active_cohorts for Apex
    patch_sarah = requests.patch(
        f"{API_BASE}/organizations/apex-univ/settings/cohorts.max_active_cohorts",
        headers=sarah_headers,
        json={"value": 15}
    )
    assert_true(patch_sarah.status_code == 200, "Org Admin successfully updates permitted setting")
    assert_true(patch_sarah.json()["value"] == 15, "Org Admin receives updated setting value 15")

    # Verify single GET returns updated value
    get_sarah = requests.get(f"{API_BASE}/organizations/apex-univ/settings/cohorts.max_active_cohorts", headers=sarah_headers)
    assert_true(get_sarah.status_code == 200, "Single setting GET succeeds")
    assert_true(get_sarah.json()["value"] == 15, "Single setting GET returns updated value 15")

    # 3. Sarah cannot enable a disabled setting (calls platform admin endpoint -> 403)
    sarah_enable_attempt = requests.post(
        f"{API_BASE}/admin/organizations/apex-univ/settings/analytics.export_enabled/enable",
        headers=sarah_headers
    )
    assert_true(sarah_enable_attempt.status_code == 403, "Org Admin receives 403 attempting to call platform enable")

    # 4. Sarah cannot modify another organization's settings (Cloudscale)
    cross_org_patch = requests.patch(
        f"{API_BASE}/organizations/cloudscale/settings/cohorts.max_active_cohorts",
        headers={"Authorization": f"Bearer {sarah_token}", "X-Organization-Slug": "cloudscale"},
        json={"value": 99}
    )
    assert_true(cross_org_patch.status_code == 403, "Org Admin receives 403 attempting to modify another org's settings")

    print_header("6. PLATFORM RBAC & FINE-GRAINED PERMISSION ENFORCEMENT")

    # 1. Login Kai (Curriculum Lead - platform staff without organization_settings.manage)
    login_kai = requests.post(f"{API_BASE}/login", json={"email": "kai.curriculum@example.com", "password": "Password123!"})
    assert_true(login_kai.status_code == 200, "Curriculum Lead login succeeds")
    kai_token = login_kai.json()["access_token"]
    kai_headers = {"Authorization": f"Bearer {kai_token}"}

    kai_admin_req = requests.get(f"{API_BASE}/admin/organizations/apex-univ/settings", headers=kai_headers)
    assert_true(kai_admin_req.status_code == 403, "Curriculum Lead without 'organization_settings.manage' gets 403")

    # 2. Login Sam (Support Staff - platform staff without organization_settings.manage)
    login_sam = requests.post(f"{API_BASE}/login", json={"email": "sam.support@example.com", "password": "Password123!"})
    assert_true(login_sam.status_code == 200, "Support Staff login succeeds")
    sam_token = login_sam.json()["access_token"]
    sam_headers = {"Authorization": f"Bearer {sam_token}"}

    sam_admin_req = requests.get(f"{API_BASE}/admin/organizations/apex-univ/settings", headers=sam_headers)
    assert_true(sam_admin_req.status_code == 403, "Support Staff without 'organization_settings.manage' gets 403")

    # 3. User with organization_settings.manage (dev@example.com) succeeds across any organization
    dev_apex = requests.get(f"{API_BASE}/admin/organizations/apex-univ/settings", headers=dev_headers)
    assert_true(dev_apex.status_code == 200, "Platform Admin with 'organization_settings.manage' accesses Apex")

    dev_cloud = requests.get(f"{API_BASE}/admin/organizations/cloudscale/settings", headers=dev_headers)
    assert_true(dev_cloud.status_code == 200, "Platform Admin with 'organization_settings.manage' accesses Cloudscale")

    print_header("7. EFFECTIVE CONFIGURATION RESOLUTION")

    # 1. Enabled setting with custom DB value resolves to custom value
    res_eff_custom = requests.get(f"{API_BASE}/organizations/apex-univ/settings/cohorts.max_active_cohorts", headers=sarah_headers)
    assert_true(res_eff_custom.json()["value"] == 15, "Enabled setting with DB value resolves to customized value (15)")

    # 2. Existing org does NOT have newly introduced setting 'learning_paths.default_visibility' enabled yet
    # Use cloudscale to test newly introduced setting isolation
    res_pre_enable = requests.get(f"{API_BASE}/organizations/cloudscale/settings/learning_paths.default_visibility", headers=dev_headers)
    assert_true(res_pre_enable.status_code == 404, "Newly introduced setting is not enabled for existing org (returns 404)")

    # Platform staff explicitly enables it for CloudScale without custom initial value
    enable_lp = requests.post(
        f"{API_BASE}/admin/organizations/cloudscale/settings/learning_paths.default_visibility/enable",
        headers=dev_headers
    )
    assert_true(enable_lp.status_code == 200, "Platform staff enables newly introduced setting for existing org")

    # Now verify it resolves to code default ('public')
    res_eff_def = requests.get(f"{API_BASE}/organizations/cloudscale/settings/learning_paths.default_visibility", headers=dev_headers)
    assert_true(res_eff_def.status_code == 200, "Enabled setting is now accessible")
    assert_true(res_eff_def.json()["value"] == "public", "Enabled setting without DB override resolves to code default ('public')")

    # Clean up so subsequent test runs remain idempotent
    requests.post(f"{API_BASE}/admin/organizations/cloudscale/settings/learning_paths.default_visibility/disable", headers=dev_headers)

    # 3. Disabled setting returns 404/None to org admin
    # Disable learning_paths.default_visibility for test org
    requests.post(f"{API_BASE}/admin/organizations/{unique_slug}/settings/learning_paths.default_visibility/disable", headers=dev_headers)
    
    # Check effective setting in DB via helper
    eff_disabled = run_sql(f"""
        SELECT osa.is_enabled 
        FROM organization_setting_availability osa 
        WHERE osa.organization_id = {test_org_id} AND osa.setting_key = 'learning_paths.default_visibility';
    """)
    assert_true(eff_disabled == "f", "Disabled setting is inactive in availability table")

    print_header("8. AUDIT LOGGING OF SETTINGS OPERATIONS")

    # Verify audit logs were created for setting operations
    recent_audits = run_sql("""
        SELECT action, entity_type, entity_id 
        FROM audit_logs 
        WHERE entity_type = 'organization_setting' 
        ORDER BY id DESC LIMIT 5;
    """)
    assert_true("organization_setting.updated" in recent_audits or "organization_setting.override" in recent_audits,
                "Audit logs recorded for setting update/override operations")
    assert_true("organization_setting.enabled" in recent_audits or "organization_setting.disabled" in recent_audits,
                "Audit logs recorded for setting enable/disable operations")

    print("\n" + "="*70)
    print("🎉 ALL MODULE E TEST SUITE CHECKS PASSED PERFECTLY! 🎉")
    print("="*70 + "\n")

if __name__ == "__main__":
    main()
