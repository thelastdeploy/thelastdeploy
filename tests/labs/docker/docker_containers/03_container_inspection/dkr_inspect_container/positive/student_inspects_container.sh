#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Container Log Path
# Lab: dkr-inspect-container
# ==============================================================================

# Step 1: Ensure docker-test directory exists
student_exec \
  --step-name "Ensure docker-test directory exists" \
  --cmd "mkdir -p ~/docker-test" \
  --expect-exit-code 0

# Step 2: Extract container log path
student_exec \
  --step-name "Extract container log path" \
  --cmd "docker inspect --format '{{.LogPath}}' inspect-target > ~/docker-test/log_path.txt" \
  --expect-exit-code 0

# Step 3: Verify log_path.txt content
student_exec \
  --step-name "Verify log_path.txt content" \
  --cmd "cat ~/docker-test/log_path.txt" \
  --expect-exit-code 0

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully inspected and saved container LogPath."
