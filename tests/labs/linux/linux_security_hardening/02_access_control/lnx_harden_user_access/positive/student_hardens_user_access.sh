#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Audits and Hardens User Access Controls
# Lab: lnx-harden-user-access
# ==============================================================================

# Step 1: Create the access-test workspace directory
student_exec \
  --step-name "Create access-test directory" \
  --cmd "mkdir -p ~/access-test" \
  --expect-exit-code 0

# Step 2: Inspect user password aging policies in login.defs
student_exec \
  --step-name "Inspect password aging policies" \
  --cmd "grep -E 'PASS_MAX_DAYS|PASS_MIN_DAYS' /etc/login.defs || true" \
  --expect-exit-code 0

# Step 3: Record verification indicator in access_summary.txt
student_exec \
  --step-name "Record access hardening summary" \
  --cmd "echo 'USER_ACCESS_HARDENED' > ~/access-test/access_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify access summary content
student_exec \
  --step-name "Verify access summary file" \
  --cmd "cat ~/access-test/access_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "USER_ACCESS_HARDENED"

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: User access controls hardening verified."
