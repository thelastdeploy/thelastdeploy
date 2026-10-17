#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Identifies System Log Locations
# Lab: lnx-identify-system-logs
# ==============================================================================

# Step 1: Ensure log-test directory exists
student_exec \
  --step-name "Ensure log-test directory exists" \
  --cmd "mkdir -p ~/log-test" \
  --expect-exit-code 0

# Step 2: Save the auth log filename to auth_file.txt
student_exec \
  --step-name "Save authentication log filename" \
  --cmd "echo 'auth.log' > ~/log-test/auth_file.txt" \
  --expect-exit-code 0

# Step 3: Verify content of auth_file.txt
student_exec \
  --step-name "Verify auth_file.txt content" \
  --cmd "cat ~/log-test/auth_file.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "auth.log"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Authentication log file identification verified."
