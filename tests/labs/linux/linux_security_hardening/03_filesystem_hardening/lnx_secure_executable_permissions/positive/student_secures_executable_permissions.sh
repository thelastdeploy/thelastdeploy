#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Audits SUID/SGID Binaries and Secures Permissions
# Lab: lnx-secure-executable-permissions
# ==============================================================================

set -euo pipefail

LAB_ID="lnx-secure-executable-permissions"

# Step 1: Ensure fs-sec-test directory exists
student_exec "mkdir -p ~/fs-sec-test" \
    --desc "Student prepares fs-sec-test directory" \
    --expect-exit 0

# Step 2: Audit system for SUID/SGID executable binaries
student_exec "find / -perm -4000 -type f 2>/dev/null | head -n 10 || true" \
    --desc "Student audits SUID executables" \
    --expect-exit 0

# Step 3: Record verification indicator in suid_summary.txt
student_exec "echo 'SUID_PERMISSIONS_AUDITED' > ~/fs-sec-test/suid_summary.txt" \
    --desc "Student writes SUID audit summary" \
    --expect-exit 0

# Step 4: Verify suid_summary.txt content
student_exec "cat ~/fs-sec-test/suid_summary.txt" \
    --desc "Student verifies suid_summary.txt content" \
    --expect-exit 0 \
    --expect-stdout "SUID_PERMISSIONS_AUDITED"

# Step 5: Execute validator verification via tld check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: SUID/SGID executable permissions security verified."
