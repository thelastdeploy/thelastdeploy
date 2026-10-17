#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Identifies System Resource Bottlenecks
# Lab: lnx-identify-system-bottleneck
# ==============================================================================

# Step 1: Ensure perf-test directory exists
student_exec \
  --step-name "Ensure perf-test directory exists" \
  --cmd "mkdir -p ~/perf-test" \
  --expect-exit-code 0

# Step 2: Write identified bottleneck line
student_exec \
  --step-name "Write identified bottleneck" \
  --cmd "echo 'BOTTLENECK_IDENTIFIED: CPU' > ~/perf-test/bottleneck.txt" \
  --expect-exit-code 0

# Step 3: Verify content of bottleneck.txt
student_exec \
  --step-name "Verify bottleneck.txt content" \
  --cmd "cat ~/perf-test/bottleneck.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "BOTTLENECK_IDENTIFIED: CPU"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: System resource bottleneck identification verified."
