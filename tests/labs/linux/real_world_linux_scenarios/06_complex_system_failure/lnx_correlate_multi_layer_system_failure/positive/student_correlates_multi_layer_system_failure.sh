#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Correlates Multi-Layer System Failure
# Lab: lnx-correlate-multi-layer-system-failure
# ==============================================================================

# Step 1: Ensure complex-failure directory exists
student_exec \
  --step-name "Ensure complex-failure directory exists" \
  --cmd "mkdir -p ~/complex-failure" \
  --expect-exit-code 0

# Step 2: Inspect system health across layers
student_exec \
  --step-name "Inspect system health across layers" \
  --cmd "df -h && free -m && uptime" \
  --expect-exit-code 0

# Step 3: Write cascading recovery marker
student_exec \
  --step-name "Write cascading recovery marker" \
  --cmd "echo 'CASCADING_MULTI_LAYER_FAILURE_RESOLVED' > ~/complex-failure/cascading_recovery.log" \
  --expect-exit-code 0

# Step 4: Verify cascading recovery log content
student_exec \
  --step-name "Verify cascading recovery log content" \
  --cmd "cat ~/complex-failure/cascading_recovery.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "CASCADING_MULTI_LAYER_FAILURE_RESOLVED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Correlate Multi-Layer System Failure verified successfully."
