"""
Comprehensive Test Suite for Module G: Analytics & Reporting
Verifying Organization Isolation, Learner Analytics, Cohort Analytics,
Learning Path Analytics, Content Analytics, XP Distribution,
Time-Based Trends, Platform Analytics, Permissions, and CSV Exports.
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
    print_header("1. CONTEXT SETUP & AUTHENTICATION")

    # 1. Login platform devuser (Platform Admin)
    login_dev = requests.post(f"{API_BASE}/login", json={"email": "dev@example.com", "password": "devpassword123"})
    assert_true(login_dev.status_code == 200, "Platform superadmin login succeeds")
    dev_token = login_dev.json()["access_token"]
    dev_headers = {"Authorization": f"Bearer {dev_token}"}

    # 2. Login Apex University org admin (Sarah Apex)
    login_sarah = requests.post(f"{API_BASE}/login", json={"email": "sarah.apex@example.com", "password": "Password123!"})
    assert_true(login_sarah.status_code == 200, "Apex University org admin login succeeds")
    sarah_token = login_sarah.json()["access_token"]
    sarah_headers = {"Authorization": f"Bearer {sarah_token}", "X-Organization-Slug": "apex-univ"}

    # 3. Login CloudScale org admin (Marcus Cloud)
    login_marcus = requests.post(f"{API_BASE}/login", json={"email": "marcus.cloud@example.com", "password": "Password123!"})
    assert_true(login_marcus.status_code == 200, "CloudScale org admin login succeeds")
    marcus_token = login_marcus.json()["access_token"]
    marcus_headers = {"Authorization": f"Bearer {marcus_token}", "X-Organization-Slug": "cloudscale"}

    # 4. Register a dedicated test learner in Apex University
    learner_id_str = uuid.uuid4().hex[:6]
    learner_email = f"learner_modg_{learner_id_str}@example.com"
    reg_res = requests.post(f"{API_BASE}/register", json={
        "email": learner_email,
        "username": f"user_modg_{learner_id_str}",
        "password": "Password123!"
    })
    assert_true(reg_res.status_code in (200, 201), "Dedicated test learner registered")
    login_lrn = requests.post(f"{API_BASE}/login", json={"email": learner_email, "password": "Password123!"})
    lrn_token = login_lrn.json()["access_token"]
    learner_user_id = int(run_sql(f"SELECT id FROM users WHERE email='{learner_email}';"))
    lrn_headers = {"Authorization": f"Bearer {lrn_token}", "X-Organization-Slug": "apex-univ"}

    # Add learner to apex-univ via invite/membership in DB for clean testing
    run_sql(f"""
        INSERT INTO organization_memberships (organization_id, user_id, status, total_xp, unverified_xp, joined_at, created_at, updated_at)
        VALUES (13, {learner_user_id}, 'active', 0, 0, NOW(), NOW(), NOW())
        ON CONFLICT DO NOTHING;
    """)
    mem_id = run_sql(f"SELECT id FROM organization_memberships WHERE organization_id=13 AND user_id={learner_user_id};")
    run_sql(f"""
        INSERT INTO membership_roles (membership_id, role_id, assigned_at)
        SELECT {mem_id}, id, NOW() FROM roles WHERE slug='learner'
        ON CONFLICT DO NOTHING;
    """)

    print_header("2. ORGANIZATION ISOLATION")
    # Sarah (apex-univ) accessing apex-univ overview
    res = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/overview", headers=sarah_headers)
    assert_true(res.status_code == 200, "Sarah can access apex-univ analytics overview")
    apex_overview = res.json()
    assert_true(apex_overview["organization_slug"] == "apex-univ", "Overview returns correct org slug")
    assert_true(apex_overview["total_members"] > 0, "Overview reports positive member count")

    # Sarah attempting to access cloudscale analytics -> 403 Forbidden
    res_cross = requests.get(f"{API_BASE}/organizations/cloudscale/analytics/overview", headers=sarah_headers)
    assert_true(res_cross.status_code == 403, "Sarah cannot access CloudScale analytics (403 Forbidden)")

    # Marcus attempting to access apex-univ analytics -> 403 Forbidden
    res_cross2 = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/overview", headers=marcus_headers)
    assert_true(res_cross2.status_code == 403, "Marcus cannot access Apex University analytics (403 Forbidden)")

    print_header("3. LEARNER ANALYTICS & DRILLDOWN")
    # Fetch learner list
    res = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/learners", headers=sarah_headers)
    assert_true(res.status_code == 200, "Learner analytics list returns 200 OK")
    learners = res.json()
    assert_true(len(learners) > 0, "Learners list is non-empty")
    assert_true(any(l["username"] == f"user_modg_{learner_id_str}" for l in learners), "Newly joined learner appears in list")

    # Drilldown for learner without progress
    res = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/learners/{learner_user_id}", headers=sarah_headers)
    assert_true(res.status_code == 200, "Learner detail returns 200 OK for learner with zero completions")
    detail_zero = res.json()
    assert_true(detail_zero["learner"]["user_id"] == learner_user_id, "Correct learner user ID returned")
    assert_true(detail_zero["learner"]["completed_labs_count"] == 0, "Zero completed labs reported")
    assert_true(detail_zero["learner"]["completed_sections_count"] == 0, "Zero completed sections reported")
    assert_true(len(detail_zero["completed_labs"]) == 0, "Empty completed labs list")

    # Non-existent learner user ID -> 404 Not Found
    res = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/learners/999999", headers=sarah_headers)
    assert_true(res.status_code == 404, "Non-existent user in org returns 404 Not Found")

    # Search filter on learners
    res_search = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/learners?search=user_modg_{learner_id_str}", headers=sarah_headers)
    assert_true(res_search.status_code == 200, "Search query returns 200 OK")
    assert_true(len(res_search.json()) == 1, "Search returns exact matching learner")

    print_header("4. COHORT ANALYTICS & DRILLDOWN")
    # Fetch cohort list
    res = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/cohorts", headers=sarah_headers)
    assert_true(res.status_code == 200, "Cohort analytics returns 200 OK")
    cohorts = res.json()
    assert_true(len(cohorts) > 0, "Apex University cohorts found")
    first_cohort = cohorts[0]
    cohort_id = first_cohort["cohort_id"]

    # Cohort detail drilldown
    res_cd = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/cohorts/{cohort_id}", headers=sarah_headers)
    assert_true(res_cd.status_code == 200, "Cohort detail returns 200 OK")
    cd_data = res_cd.json()
    assert_true("cohort" in cd_data and "learners" in cd_data and "activity_trends" in cd_data, "Cohort detail has required sections")
    assert_true(cd_data["cohort"]["cohort_id"] == cohort_id, "Cohort detail matches requested cohort_id")

    # Non-existent cohort -> 404 Not Found
    res_cd_bad = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/cohorts/999999", headers=sarah_headers)
    assert_true(res_cd_bad.status_code == 404, "Invalid cohort returns 404 Not Found")

    print_header("5. LEARNING PATH ANALYTICS")
    res = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/paths", headers=sarah_headers)
    assert_true(res.status_code == 200, "Learning path analytics returns 200 OK")
    paths = res.json()
    assert_true(len(paths) > 0, "Learning paths list returned")
    first_path = paths[0]
    path_id = first_path["path_id"]

    # Path detail drilldown
    res_pd = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/paths/{path_id}", headers=sarah_headers)
    assert_true(res_pd.status_code == 200, "Path detail returns 200 OK")
    pd_data = res_pd.json()
    assert_true(pd_data["path"]["path_id"] == path_id, "Path detail matches requested path_id")
    assert_true("modules" in pd_data, "Path detail contains module list")

    # Non-existent path -> 404 Not Found
    res_pd_bad = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/paths/999999", headers=sarah_headers)
    assert_true(res_pd_bad.status_code == 404, "Invalid path returns 404 Not Found")

    print_header("6. CONTENT ANALYTICS & OWNERSHIP SEPARATION")
    res = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/content", headers=sarah_headers)
    assert_true(res.status_code == 200, "Content analytics returns 200 OK")
    content_data = res.json()
    assert_true("most_completed_modules" in content_data, "Most completed modules present")
    assert_true("most_completed_sections" in content_data, "Most completed sections present")
    assert_true("most_completed_labs" in content_data, "Most completed labs present")
    assert_true("verified_modules_count" in content_data, "Verified modules count present")
    assert_true(content_data["tld_owned_modules_count"] > 0, "TLD-owned modules correctly counted")
    assert_true(content_data["org_owned_modules_count"] >= 0, "Org-owned modules correctly counted")

    print_header("7. XP ANALYTICS & AUTHORITATIVE ACCOUNTING")
    res = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/xp", headers=sarah_headers)
    assert_true(res.status_code == 200, "XP analytics returns 200 OK")
    xp_data = res.json()
    assert_true("total_verified_xp" in xp_data, "Total verified XP present")
    assert_true("distribution" in xp_data, "XP distribution brackets present")
    assert_true(len(xp_data["distribution"]) == 5, "5 XP distribution brackets present")
    assert_true(xp_data["max_xp"] >= xp_data["min_xp"], "Max XP >= Min XP")

    # Authoritative verification against organization_memberships table
    db_xp = run_sql("SELECT COALESCE(SUM(total_xp), 0) FROM organization_memberships WHERE organization_id=13 AND status='active';")
    assert_true(int(db_xp) == xp_data["total_verified_xp"], f"Authoritative XP matches DB exact value ({db_xp} == {xp_data['total_verified_xp']})")

    print_header("8. TIME-BASED TRENDS & DATE FILTERING")
    # Test 7d, 30d, 90d, all presets
    for p in ["7d", "30d", "90d", "all"]:
        res_t = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/trends?period={p}", headers=sarah_headers)
        assert_true(res_t.status_code == 200, f"Trends with period={p} returns 200 OK")
        t_data = res_t.json()
        assert_true(len(t_data["lab_completions"]) >= 0, f"Lab completions array present for {p}")
        assert_true(len(t_data["section_completions"]) >= 0, f"Section completions array present for {p}")
        assert_true(len(t_data["xp_earned"]) >= 0, f"XP earned array present for {p}")

    # Custom date range
    res_custom = requests.get(
        f"{API_BASE}/organizations/apex-univ/analytics/trends?period=custom&start_date=2026-10-01T00:00:00Z&end_date=2026-11-23T23:59:59Z",
        headers=sarah_headers
    )
    assert_true(res_custom.status_code == 200, "Custom date range trends return 200 OK")

    print_header("9. PERMISSION BOUNDARIES & RBAC ENFORCEMENT")
    # Learner without analytics.view permission -> 403 Forbidden
    res_lrn_ov = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/overview", headers=lrn_headers)
    assert_true(res_lrn_ov.status_code == 403, "Learner without analytics.view gets 403 Forbidden for overview")

    res_lrn_cohorts = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/cohorts", headers=lrn_headers)
    assert_true(res_lrn_cohorts.status_code == 403, "Learner gets 403 Forbidden for cohorts analytics")

    # Sarah (Org Admin) accessing Platform-level analytics -> 403 Forbidden
    res_sarah_platform = requests.get(f"{API_BASE}/platform/analytics/overview", headers=sarah_headers)
    assert_true(res_sarah_platform.status_code == 403, "Org Admin cannot access Platform-level analytics (403 Forbidden)")

    # Devuser (Platform Superadmin) accessing Platform-level analytics -> 200 OK
    res_dev_platform = requests.get(f"{API_BASE}/platform/analytics/overview", headers=dev_headers)
    assert_true(res_dev_platform.status_code == 200, "Platform Superadmin accesses platform overview (200 OK)")
    pl_data = res_dev_platform.json()
    assert_true(pl_data["total_users"] > 0, "Platform total users > 0")
    assert_true(pl_data["total_organizations"] > 0, "Platform total organizations > 0")

    # Platform trends
    res_dev_trends = requests.get(f"{API_BASE}/platform/analytics/trends?period=30d", headers=dev_headers)
    assert_true(res_dev_trends.status_code == 200, "Platform trends return 200 OK")

    # Platform organizations summary
    res_dev_orgs = requests.get(f"{API_BASE}/platform/analytics/organizations", headers=dev_headers)
    assert_true(res_dev_dev_orgs := res_dev_orgs.status_code == 200, "Platform organizations list returns 200 OK")
    assert_true(len(res_dev_orgs.json()) > 0, "Platform organizations list non-empty")

    print_header("10. CSV EXPORT & SETTING ENFORCEMENT")
    # Step A: Ensure analytics.export_enabled is False in apex-univ
    requests.patch(
        f"{API_BASE}/organizations/apex-univ/settings/analytics.export_enabled",
        headers=sarah_headers,
        json={"value": False}
    )

    # When export_enabled is False -> 403 Forbidden
    res_exp_blocked = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/export/learners", headers=sarah_headers)
    assert_true(res_exp_blocked.status_code == 403, "Export blocked with 403 when analytics.export_enabled is False")
    assert_true("disabled for this organization" in res_exp_blocked.json().get("detail", ""), "Correct disabled error message returned")

    # Step B: Enable analytics.export_enabled via platform admin and org admin
    requests.post(
        f"{API_BASE}/admin/organizations/apex-univ/settings/analytics.export_enabled/enable",
        headers=dev_headers,
        json={"initial_value": True}
    )
    requests.patch(
        f"{API_BASE}/organizations/apex-univ/settings/analytics.export_enabled",
        headers=sarah_headers,
        json={"value": True}
    )

    # Step C: Verify all 4 export types produce valid CSV
    for exp_type in ["learners", "activity", "cohorts", "content"]:
        res_exp = requests.get(f"{API_BASE}/organizations/apex-univ/analytics/export/{exp_type}", headers=sarah_headers)
        assert_true(res_exp.status_code == 200, f"Export '{exp_type}' returns 200 OK when enabled")
        assert_true("text/csv" in res_exp.headers.get("Content-Type", ""), f"Export '{exp_type}' has Content-Type text/csv")
        lines = res_exp.text.strip().splitlines()
        assert_true(len(lines) >= 1, f"Export '{exp_type}' has header row")

    # Step D: Platform Export
    res_pl_exp = requests.get(f"{API_BASE}/platform/analytics/export/organizations", headers=dev_headers)
    assert_true(res_pl_exp.status_code == 200, "Platform organizations export returns 200 OK")
    assert_true("text/csv" in res_pl_exp.headers.get("Content-Type", ""), "Platform export has Content-Type text/csv")

    # Step E: Reset setting back to disabled
    requests.patch(
        f"{API_BASE}/organizations/apex-univ/settings/analytics.export_enabled",
        headers=sarah_headers,
        json={"value": False}
    )

    print_header("ALL MODULE G TESTS PASSED SUCCESSFULLY!")


if __name__ == "__main__":
    main()
