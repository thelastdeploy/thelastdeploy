#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Slow Application Response
# Lab: lnx-investigate-slow-application
# ==============================================================================

# Step 1: Ensure app-perf-test directory exists
student_exec \
  --step-name "Ensure app-perf-test directory exists" \
  --cmd "mkdir -p ~/app-perf-test" \
  --expect-exit-code 0

# Step 2: Check system load and stats
student_exec \
  --step-name "Check system load via uptime" \
  --cmd "uptime" \
  --expect-exit-code 0

# Step 3: Write application latency analysis marker
student_exec \
  --step-name "Write application latency marker" \
  --cmd "echo 'APPLICATION_LATENCY_INVESTIGATED' > ~/app-perf-test/app_latency.txt" \
  --expect-exit-code 0

# Step 4: Verify content of app_latency.txt
student_exec \
  --step-name "Verify app_latency.txt content" \
  --cmd "cat ~/app-perf-test/app_latency.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "APPLICATION_LATENCY_INVESTIGATED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Slow application response investigation verified."
