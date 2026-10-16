#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Audits and Hardens User Access Controls
# Lab: lnx-harden-user-access
# ==============================================================================

set -euo pipefail

LAB_ID="lnx-harden-user-access"

# Step 1: Create the access-test workspace directory
student_exec "mkdir -p ~/access-test" \
    --desc "Student prepares access-test directory" \
    --expect-exit 0

# Step 2: Inspect user password aging policies in login.defs
student_exec "grep -E 'PASS_MAX_DAYS|PASS_MIN_DAYS' /etc/login.defs || true" \
    --desc "Student inspects password aging policies" \
    --expect-exit 0

# Step 3: Record verification indicator in access_summary.txt
student_exec "echo 'USER_ACCESS_HARDENED' > ~/access-test/access_summary.txt" \
    --desc "Student writes access hardening summary" \
    --expect-exit 0

# Step 4: Verify access summary content
student_exec "cat ~/access-test/access_summary.txt" \
    --desc "Student verifies access summary content" \
    --expect-exit 0 \
    --expect-stdout "USER_ACCESS_HARDENED"

# Step 5: Execute validator verification via tld check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: User access controls hardening verified."
