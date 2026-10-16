#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Diagnoses Failed Service Root Cause
# Lab: lnx-diagnose-failed-service
# ==============================================================================

# Step 1: Ensure fail-test directory exists
student_exec \
  --step-name "Create fail-test directory" \
  --cmd "mkdir -p ~/fail-test" \
  --expect-exit-code 0

# Step 2: Write diagnosis root cause to diag_report.txt
student_exec \
  --step-name "Record failure diagnosis" \
  --cmd "echo 'REASON: missing_executable' > ~/fail-test/diag_report.txt" \
  --expect-exit-code 0

# Step 3: Verify diag_report.txt content
student_exec \
  --step-name "Verify diag_report.txt content" \
  --cmd "cat ~/fail-test/diag_report.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "REASON: missing_executable"

# Step 4: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Failed service diagnosis verified."
