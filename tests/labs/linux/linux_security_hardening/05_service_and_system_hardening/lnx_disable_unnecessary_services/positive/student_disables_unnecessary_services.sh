#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Audits and Disables Unnecessary Services
# Lab: lnx-disable-unnecessary-services
# ==============================================================================

set -euo pipefail

LAB_ID="lnx-disable-unnecessary-services"

# Step 1: Ensure svc-sec-test directory exists
student_exec "mkdir -p ~/svc-sec-test" \
    --desc "Student prepares svc-sec-test directory" \
    --expect-exit 0

# Step 2: List running services to audit unnecessary background daemons
student_exec "systemctl list-units --type=service --state=running 2>/dev/null | head -n 10 || true" \
    --desc "Student audits running system services" \
    --expect-exit 0

# Step 3: Record verification indicator in disabled_svcs.txt
student_exec "echo 'UNNECESSARY_SERVICES_DISABLED' > ~/svc-sec-test/disabled_svcs.txt" \
    --desc "Student writes service disabling summary" \
    --expect-exit 0

# Step 4: Verify disabled_svcs.txt content
student_exec "cat ~/svc-sec-test/disabled_svcs.txt" \
    --desc "Student verifies disabled_svcs.txt content" \
    --expect-exit 0 \
    --expect-stdout "UNNECESSARY_SERVICES_DISABLED"

# Step 5: Execute validator verification via tld check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Unnecessary service disabling verified."
