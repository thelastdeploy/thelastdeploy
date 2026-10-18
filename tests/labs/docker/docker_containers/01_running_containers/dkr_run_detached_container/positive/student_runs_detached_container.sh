#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Runs a Detached Container
# Lab: dkr-run-detached-container
# ==============================================================================

# Step 1: Clean existing container if present
student_exec \
  --step-name "Clean existing container" \
  --cmd "docker rm -f background-sleeper 2>/dev/null || true" \
  --expect-exit-code 0

# Step 2: Run detached container named background-sleeper
student_exec \
  --step-name "Run detached container" \
  --cmd "docker run -d --name background-sleeper alpine sleep 500" \
  --expect-exit-code 0

# Step 3: Verify container running state
student_exec \
  --step-name "Verify container is running" \
  --cmd "docker inspect background-sleeper --format '{{.State.Running}}'" \
  --expect-exit-code 0 \
  --expect-stdout-contains "true"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Detached container started successfully."
