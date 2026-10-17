#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Establishes System Performance Baseline
# Lab: lnx-establish-performance-baseline
# ==============================================================================

# Step 1: Ensure perf-test directory exists
student_exec \
  --step-name "Ensure perf-test directory exists" \
  --cmd "mkdir -p ~/perf-test" \
  --expect-exit-code 0

# Step 2: Measure system baseline metrics
student_exec \
  --step-name "Measure baseline metrics" \
  --cmd "uptime && free -h && df -h" \
  --expect-exit-code 0

# Step 3: Write baseline summary marker
student_exec \
  --step-name "Write baseline marker" \
  --cmd "echo 'PERFORMANCE_BASELINE_ESTABLISHED' > ~/perf-test/baseline.txt" \
  --expect-exit-code 0

# Step 4: Verify content of baseline.txt
student_exec \
  --step-name "Verify baseline.txt content" \
  --cmd "cat ~/perf-test/baseline.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PERFORMANCE_BASELINE_ESTABLISHED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: System performance baseline established."
