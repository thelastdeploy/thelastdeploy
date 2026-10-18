#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Reads Container Logs
# Lab: dkr-read-container-logs
# ==============================================================================

# Step 1: Ensure docker-test directory exists
student_exec \
  --step-name "Ensure docker-test directory exists" \
  --cmd "mkdir -p ~/docker-test" \
  --expect-exit-code 0

# Step 2: Extract secret flag from logger-app logs
student_exec \
  --step-name "Extract secret flag line" \
  --cmd "docker logs logger-app 2>&1 | grep 'SECRET_FLAG=' > ~/docker-test/container_flag.txt" \
  --expect-exit-code 0

# Step 3: Verify container_flag.txt content
student_exec \
  --step-name "Verify container_flag.txt content" \
  --cmd "cat ~/docker-test/container_flag.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SECRET_FLAG=docker_logging_master"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully retrieved the secret flag from container logs."
