#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Correlates Multiple Concurrent System Failures
# Lab: lnx-correlate-multiple-system-failures
# ==============================================================================

# Step 1: Ensure multi-inc-test directory exists
student_exec \
  --step-name "Ensure multi-inc-test directory exists" \
  --cmd "mkdir -p ~/multi-inc-test" \
  --expect-exit-code 0

# Step 2: Correlate multi-subsystem status logs
student_exec \
  --step-name "Correlate multi-subsystem status logs" \
  --cmd "dmesg | tail -n 5 && df -h | head -n 5 || true" \
  --expect-exit-code 0

# Step 3: Write failure correlation matrix marker
student_exec \
  --step-name "Write failure correlation matrix marker" \
  --cmd "echo 'FAILURES_CORRELATED: PRIMARY_CAUSE_ISOLATED' > ~/multi-inc-test/correlation_matrix.txt" \
  --expect-exit-code 0

# Step 4: Verify correlation_matrix.txt content
student_exec \
  --step-name "Verify correlation_matrix.txt content" \
  --cmd "cat ~/multi-inc-test/correlation_matrix.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "FAILURES_CORRELATED: PRIMARY_CAUSE_ISOLATED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Multiple concurrent system failures correlation verified."
