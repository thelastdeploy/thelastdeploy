#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Stops Running Container
# Lab: dkr-stop-running-container
# ==============================================================================

# Step 1: Stop container runaway-container
student_exec \
  --step-name "Stop container runaway-container" \
  --cmd "docker stop runaway-container" \
  --expect-exit-code 0

# Step 2: Verify container is stopped
student_exec \
  --step-name "Verify container is stopped" \
  --cmd "docker inspect runaway-container --format '{{.State.Running}}'" \
  --expect-exit-code 0 \
  --expect-stdout-contains "false"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Running container stopped successfully."
