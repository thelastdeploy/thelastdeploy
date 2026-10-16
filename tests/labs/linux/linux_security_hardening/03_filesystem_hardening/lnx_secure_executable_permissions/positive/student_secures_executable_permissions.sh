#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Audits SUID/SGID Binaries and Secures Permissions
# Lab: lnx-secure-executable-permissions
# ==============================================================================

# Step 1: Ensure fs-sec-test directory exists
student_exec \
  --step-name "Create fs-sec-test directory" \
  --cmd "mkdir -p ~/fs-sec-test" \
  --expect-exit-code 0

# Step 2: Audit system for SUID/SGID executable binaries
student_exec \
  --step-name "Audit SUID executables" \
  --cmd "find / -perm -4000 -type f 2>/dev/null | head -n 10 || true" \
  --expect-exit-code 0

# Step 3: Record verification indicator in suid_summary.txt
student_exec \
  --step-name "Record SUID audit summary" \
  --cmd "echo 'SUID_PERMISSIONS_AUDITED' > ~/fs-sec-test/suid_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify suid_summary.txt content
student_exec \
  --step-name "Verify suid_summary.txt content" \
  --cmd "cat ~/fs-sec-test/suid_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SUID_PERMISSIONS_AUDITED"

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: SUID/SGID executable permissions security verified."
