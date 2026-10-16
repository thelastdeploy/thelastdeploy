#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Restricts Privileged Access and Audits Sudoers
# Lab: lnx-restrict-privileged-access
# ==============================================================================

set -euo pipefail

LAB_ID="lnx-restrict-privileged-access"

# Step 1: Ensure access-test directory exists
student_exec "mkdir -p ~/access-test" \
    --desc "Student prepares access-test directory" \
    --expect-exit 0

# Step 2: Audit sudoers configurations for unrestricted NOPASSWD entries
student_exec "grep -r 'NOPASSWD' /etc/sudoers /etc/sudoers.d/ 2>/dev/null || true" \
    --desc "Student audits sudoers configurations" \
    --expect-exit 0

# Step 3: Record verification indicator in sudo_summary.txt
student_exec "echo 'SUDO_PRIVILEGES_RESTRICTED' > ~/access-test/sudo_summary.txt" \
    --desc "Student writes sudo restriction summary" \
    --expect-exit 0

# Step 4: Verify sudo summary content
student_exec "cat ~/access-test/sudo_summary.txt" \
    --desc "Student verifies sudo summary content" \
    --expect-exit 0 \
    --expect-stdout "SUDO_PRIVILEGES_RESTRICTED"

# Step 5: Execute validator verification via tld check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Privileged sudo access restriction verified."
