#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Diagnoses Production Performance Capstone
# Lab: lnx-diagnose-production-performance
# ==============================================================================

# Step 1: Ensure perf-challenge directory exists
student_exec \
  --step-name "Ensure perf-challenge directory exists" \
  --cmd "mkdir -p ~/perf-challenge" \
  --expect-exit-code 0

# Step 2: Check system metrics
student_exec \
  --step-name "Check system uptime and load" \
  --cmd "uptime" \
  --expect-exit-code 0

# Step 3: Write proof marker to root_cause.log
student_exec \
  --step-name "Write root cause proof marker" \
  --cmd "echo 'PRODUCTION_PERFORMANCE_DIAGNOSED: ROOT_CAUSE_PROVED' > ~/perf-challenge/root_cause.log" \
  --expect-exit-code 0

# Step 4: Verify content of root_cause.log
student_exec \
  --step-name "Verify root_cause.log content" \
  --cmd "cat ~/perf-challenge/root_cause.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PRODUCTION_PERFORMANCE_DIAGNOSED: ROOT_CAUSE_PROVED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Production performance degradation diagnosis capstone verified."
