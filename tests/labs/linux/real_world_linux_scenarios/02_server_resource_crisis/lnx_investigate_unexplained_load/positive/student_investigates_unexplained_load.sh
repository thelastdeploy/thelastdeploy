#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Unexplained High Load Average
# Lab: lnx-investigate-unexplained-load
# ==============================================================================

# Step 1: Ensure resource-crisis directory exists
student_exec \
  --step-name "Ensure resource-crisis directory exists" \
  --cmd "mkdir -p ~/resource-crisis" \
  --expect-exit-code 0

# Step 2: Analyze system load and uninterruptible sleep state
student_exec \
  --step-name "Analyze system load and uninterruptible sleep state" \
  --cmd "uptime && ps aux | head -n 5" \
  --expect-exit-code 0

# Step 3: Write high load analysis marker
student_exec \
  --step-name "Write high load analysis marker" \
  --cmd "echo 'UNEXPLAINED_HIGH_LOAD_DIAGNOSED_AND_RESOLVED' > ~/resource-crisis/high_load_analysis.log" \
  --expect-exit-code 0

# Step 4: Verify analysis log content
student_exec \
  --step-name "Verify analysis log content" \
  --cmd "cat ~/resource-crisis/high_load_analysis.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "UNEXPLAINED_HIGH_LOAD_DIAGNOSED_AND_RESOLVED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Investigate Unexplained High Load Average verified successfully."
