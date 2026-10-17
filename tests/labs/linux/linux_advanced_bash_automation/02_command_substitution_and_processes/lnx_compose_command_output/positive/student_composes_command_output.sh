#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Composes Command Output in Scripts
# Lab: lnx-compose-command-output
# ==============================================================================

# Step 1: Ensure sub-test directory exists
student_exec \
  --step-name "Ensure sub-test directory exists" \
  --cmd "mkdir -p ~/sub-test" \
  --expect-exit-code 0

# Step 2: Compose command output into system_info.txt
student_exec \
  --step-name "Compose system info file" \
  --cmd "echo \"ARCH: \$(uname -m)\" > ~/sub-test/system_info.txt; echo \"USER: \$(whoami)\" >> ~/sub-test/system_info.txt; echo \"DATE: \$(date +%Y-%m-%d)\" >> ~/sub-test/system_info.txt" \
  --expect-exit-code 0

# Step 3: Verify content of system_info.txt
student_exec \
  --step-name "Verify system_info.txt content" \
  --cmd "cat ~/sub-test/system_info.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "ARCH: "

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: System info command output verified."
