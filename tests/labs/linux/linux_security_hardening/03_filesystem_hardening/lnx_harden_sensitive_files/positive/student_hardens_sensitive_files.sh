#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Audits and Hardens Sensitive System Files
# Lab: lnx-harden-sensitive-files
# ==============================================================================

set -euo pipefail

LAB_ID="lnx-harden-sensitive-files"

# Step 1: Create the fs-sec-test directory
student_exec "mkdir -p ~/fs-sec-test" \
    --desc "Student prepares fs-sec-test directory" \
    --expect-exit 0

# Step 2: Audit sensitive system file permissions
student_exec "ls -l /etc/shadow /etc/passwd /etc/ssh/sshd_config 2>/dev/null || true" \
    --desc "Student audits sensitive file permissions" \
    --expect-exit 0

# Step 3: Record verification indicator in file_perms.txt
student_exec "echo 'FILE_PERMISSIONS_HARDENED' > ~/fs-sec-test/file_perms.txt" \
    --desc "Student writes file permissions hardening summary" \
    --expect-exit 0

# Step 4: Verify file_perms.txt content
student_exec "cat ~/fs-sec-test/file_perms.txt" \
    --desc "Student verifies file_perms.txt content" \
    --expect-exit 0 \
    --expect-stdout "FILE_PERMISSIONS_HARDENED"

# Step 5: Execute validator verification via tld check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Sensitive system file hardening verified."
