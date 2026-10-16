#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Audits and Hardens Sensitive System Files
# Lab: lnx-harden-sensitive-files
# ==============================================================================

# Step 1: Create the fs-sec-test directory
student_exec \
  --step-name "Create fs-sec-test directory" \
  --cmd "mkdir -p ~/fs-sec-test" \
  --expect-exit-code 0

# Step 2: Audit sensitive system file permissions
student_exec \
  --step-name "Audit sensitive file permissions" \
  --cmd "ls -l /etc/shadow /etc/passwd /etc/ssh/sshd_config 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Record verification indicator in file_perms.txt
student_exec \
  --step-name "Record file permissions hardening summary" \
  --cmd "echo 'FILE_PERMISSIONS_HARDENED' > ~/fs-sec-test/file_perms.txt" \
  --expect-exit-code 0

# Step 4: Verify file_perms.txt content
student_exec \
  --step-name "Verify file_perms.txt content" \
  --cmd "cat ~/fs-sec-test/file_perms.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "FILE_PERMISSIONS_HARDENED"

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Sensitive system file hardening verified."
