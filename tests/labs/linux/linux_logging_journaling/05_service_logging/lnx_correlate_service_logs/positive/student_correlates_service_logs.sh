#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Correlates Service Status with Journal Logs
# Lab: lnx-correlate-service-logs
# ==============================================================================

# Step 1: Ensure log-test directory exists
student_exec \
  --step-name "Ensure log-test directory exists" \
  --cmd "mkdir -p ~/log-test" \
  --expect-exit-code 0

# Step 2: Save the failing service unit name to failing_unit.txt
student_exec \
  --step-name "Save failing service unit name" \
  --cmd "echo 'payment-processor.service' > ~/log-test/failing_unit.txt" \
  --expect-exit-code 0

# Step 3: Verify content of failing_unit.txt
student_exec \
  --step-name "Verify failing_unit.txt content" \
  --cmd "cat ~/log-test/failing_unit.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "payment-processor.service"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Service correlation unit identification verified."
