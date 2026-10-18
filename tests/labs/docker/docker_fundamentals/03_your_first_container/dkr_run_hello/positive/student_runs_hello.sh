#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Runs Hello-World Container
# Lab: dkr-run-hello
# ==============================================================================

# Step 1: Run hello-world container
student_exec \
  --step-name "Run hello-world container" \
  --cmd "docker run hello-world" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Hello from Docker!"

# Step 2: Verify image is listed locally
student_exec \
  --step-name "Verify hello-world image exists" \
  --cmd "docker images hello-world" \
  --expect-exit-code 0 \
  --expect-stdout-contains "hello-world"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: hello-world ran and exited cleanly"
