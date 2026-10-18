#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Crashing Container
# Lab: dkr-recover-crashing-container
# ==============================================================================

# Step 1: Inspect the broken container command
student_exec \
  --step-name "Inspect crashing-service command" \
  --cmd "docker inspect crashing-service --format '{{.Config.Cmd}}'" \
  --expect-exit-code 0

# Step 2: Remove the broken container
student_exec \
  --step-name "Remove broken container" \
  --cmd "docker rm -f crashing-service" \
  --expect-exit-code 0

# Step 3: Run fixed replacement container
student_exec \
  --step-name "Run replacement container with sleep 1000" \
  --cmd "docker run -d --name crashing-service alpine sleep 1000" \
  --expect-exit-code 0

# Step 4: Verify container is running
student_exec \
  --step-name "Verify container is running" \
  --cmd "docker inspect crashing-service --format '{{.State.Running}}'" \
  --expect-exit-code 0 \
  --expect-stdout-contains "true"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully debugged, replaced and started crashing-service."
