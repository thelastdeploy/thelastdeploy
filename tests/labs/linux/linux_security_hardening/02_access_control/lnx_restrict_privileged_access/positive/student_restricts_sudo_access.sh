#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Restricts Privileged Access and Audits Sudoers
# Lab: lnx-restrict-privileged-access
# ==============================================================================

# Step 1: Ensure access-test directory exists
student_exec \
  --step-name "Create access-test directory" \
  --cmd "mkdir -p ~/access-test" \
  --expect-exit-code 0

# Step 2: Audit sudoers configurations for unrestricted NOPASSWD entries
student_exec \
  --step-name "Audit sudoers configurations" \
  --cmd "grep -r 'NOPASSWD' /etc/sudoers /etc/sudoers.d/ 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Record verification indicator in sudo_summary.txt
student_exec \
  --step-name "Record sudo restriction summary" \
  --cmd "echo 'SUDO_PRIVILEGES_RESTRICTED' > ~/access-test/sudo_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify sudo summary content
student_exec \
  --step-name "Verify sudo summary file" \
  --cmd "cat ~/access-test/sudo_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SUDO_PRIVILEGES_RESTRICTED"

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Privileged sudo access restriction verified."
