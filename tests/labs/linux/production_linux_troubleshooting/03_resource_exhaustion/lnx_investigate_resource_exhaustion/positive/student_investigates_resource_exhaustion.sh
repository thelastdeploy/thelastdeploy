#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Severe Resource Exhaustion
# Lab: lnx-investigate-resource-exhaustion
# ==============================================================================

# Step 1: Ensure res-outage-test directory exists
student_exec \
  --step-name "Ensure res-outage-test directory exists" \
  --cmd "mkdir -p ~/res-outage-test" \
  --expect-exit-code 0

# Step 2: Inspect memory allocation and swap metrics
student_exec \
  --step-name "Inspect memory allocation and swap metrics" \
  --cmd "free -m && ps aux --sort=-%mem | head -n 5" \
  --expect-exit-code 0

# Step 3: Write resource exhaustion diagnosis marker
student_exec \
  --step-name "Write resource exhaustion diagnosis marker" \
  --cmd "echo 'RESOURCE_EXHAUSTION_DIAGNOSED' > ~/res-outage-test/exhaustion_report.txt" \
  --expect-exit-code 0

# Step 4: Verify exhaustion_report.txt content
student_exec \
  --step-name "Verify exhaustion_report.txt content" \
  --cmd "cat ~/res-outage-test/exhaustion_report.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "RESOURCE_EXHAUSTION_DIAGNOSED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Severe resource exhaustion investigation verified."
