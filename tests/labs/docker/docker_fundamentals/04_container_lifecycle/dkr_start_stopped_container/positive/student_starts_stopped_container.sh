#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Starts Stopped Container
# Lab: dkr-start-stopped-container
# ==============================================================================

# Step 1: Start container stopped-sleeper
student_exec \
  --step-name "Start container stopped-sleeper" \
  --cmd "docker start stopped-sleeper" \
  --expect-exit-code 0

# Step 2: Verify container is running
student_exec \
  --step-name "Verify container is running" \
  --cmd "docker inspect stopped-sleeper --format '{{.State.Running}}'" \
  --expect-exit-code 0 \
  --expect-stdout-contains "true"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Stopped container started successfully."
