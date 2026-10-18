#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Runs Alpine Container
# Lab: dkr-run-alpine-container
# ==============================================================================

# Step 1: Remove existing container if present
student_exec \
  --step-name "Clean any existing container" \
  --cmd "docker rm -f my-alpine-run 2>/dev/null || true" \
  --expect-exit-code 0

# Step 2: Run alpine container echoing Hello from Alpine
student_exec \
  --step-name "Run alpine container" \
  --cmd "docker run --name my-alpine-run alpine echo 'Hello from Alpine'" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Hello from Alpine"

# Step 3: Verify container logs
student_exec \
  --step-name "Verify container logs" \
  --cmd "docker logs my-alpine-run" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Hello from Alpine"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Alpine container ran and outputted correctly."
