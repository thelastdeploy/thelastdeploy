#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Names a Container
# Lab: dkr-name-a-container
# ==============================================================================

# Step 1: Clean existing container if present
student_exec \
  --step-name "Clean existing container" \
  --cmd "docker rm -f custom-app 2>/dev/null || true" \
  --expect-exit-code 0

# Step 2: Run container with name custom-app
student_exec \
  --step-name "Run container named custom-app" \
  --cmd "docker run -d --name custom-app alpine sleep 1000" \
  --expect-exit-code 0

# Step 3: Verify container running state
student_exec \
  --step-name "Verify container is running" \
  --cmd "docker inspect custom-app --format '{{.State.Running}}'" \
  --expect-exit-code 0 \
  --expect-stdout-contains "true"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Container custom-app successfully started."
