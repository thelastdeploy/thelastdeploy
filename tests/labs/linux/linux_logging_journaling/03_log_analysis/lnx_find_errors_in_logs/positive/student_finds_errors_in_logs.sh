#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Extracts Errors and Fatal Exceptions from Logs
# Lab: lnx-find-errors-in-logs
# ==============================================================================

# Step 1: Ensure log-test directory exists with sample app.log if missing
student_exec \
  --step-name "Ensure sample app.log exists" \
  --cmd "mkdir -p ~/log-test && [ -f ~/log-test/app.log ] || printf '[INFO] Server started\n[ERROR] Connection timeout\n[INFO] Request processed\n[FATAL] Out of memory\n' > ~/log-test/app.log" \
  --expect-exit-code 0

# Step 2: Extract ERROR and FATAL lines to error_summary.log
student_exec \
  --step-name "Extract ERROR and FATAL lines" \
  --cmd "grep -E 'ERROR|FATAL' ~/log-test/app.log > ~/log-test/error_summary.log" \
  --expect-exit-code 0

# Step 3: Verify content of error_summary.log
student_exec \
  --step-name "Verify error_summary.log content" \
  --cmd "cat ~/log-test/error_summary.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Connection timeout"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Error and fatal log extraction verified."
