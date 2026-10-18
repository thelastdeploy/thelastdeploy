#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Finds Container Error
# Lab: dkr-find-container-error
# ==============================================================================

# Step 1: Ensure docker-test directory exists
student_exec \
  --step-name "Ensure docker-test directory exists" \
  --cmd "mkdir -p ~/docker-test" \
  --expect-exit-code 0

# Step 2: Extract error message from buggy-app logs
student_exec \
  --step-name "Extract critical error message" \
  --cmd "docker logs buggy-app 2>&1 | grep 'CRITICAL_ERROR:' | awk -F': ' '{print \$2}' > ~/docker-test/error_msg.txt" \
  --expect-exit-code 0

# Step 3: Verify error_msg.txt content
student_exec \
  --step-name "Verify error_msg.txt content" \
  --cmd "cat ~/docker-test/error_msg.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "db_connection_failed"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully extracted the critical error log."
