#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Limits Container Memory
# Lab: dkr-limit-container-memory
# ==============================================================================

# Step 1: Start container with memory limit of 128m
student_exec \
  --step-name "Start memory-capped container with 128m limit" \
  --cmd "docker run -d --name memory-capped -m 128m alpine sleep 1000" \
  --expect-exit-code 0

# Step 2: Verify memory limit via docker inspect
student_exec \
  --step-name "Verify memory limit via docker inspect" \
  --cmd "docker inspect memory-capped --format '{{.HostConfig.Memory}}'" \
  --expect-exit-code 0 \
  --expect-stdout-contains "134217728"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Container memory limit successfully verified."
