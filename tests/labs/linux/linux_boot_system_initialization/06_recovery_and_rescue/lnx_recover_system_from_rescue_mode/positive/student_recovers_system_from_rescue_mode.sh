#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers System from Rescue Target
# Lab: lnx-recover-system-from-rescue-mode
# ==============================================================================

# Step 1: Ensure rescue-test directory exists
student_exec \
  --step-name "Ensure rescue-test directory exists" \
  --cmd "mkdir -p ~/rescue-test" \
  --expect-exit-code 0

# Step 2: Write rescue summary line to rescue_summary.txt
student_exec \
  --step-name "Write rescue recovery summary" \
  --cmd "echo 'RESCUE_MODE_RECOVERY_VERIFIED' > ~/rescue-test/rescue_summary.txt" \
  --expect-exit-code 0

# Step 3: Verify content of rescue_summary.txt
student_exec \
  --step-name "Verify rescue_summary.txt content" \
  --cmd "cat ~/rescue-test/rescue_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "RESCUE_MODE_RECOVERY_VERIFIED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: System recovery from rescue mode verified."
