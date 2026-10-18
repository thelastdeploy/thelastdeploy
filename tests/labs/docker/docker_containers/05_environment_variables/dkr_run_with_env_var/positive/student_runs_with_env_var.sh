#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Runs Container With Environment Variables
# Lab: dkr-run-with-env-var
# ==============================================================================

# Step 1: Start container with required environment variables
student_exec \
  --step-name "Start env-app container with APP_ENV and DEBUG" \
  --cmd "docker run -d --name env-app -e APP_ENV=production -e DEBUG=false alpine sleep 1000" \
  --expect-exit-code 0

# Step 2: Verify environment variables inside container
student_exec \
  --step-name "Verify environment variables inside container" \
  --cmd "docker exec env-app env | grep -E '^(APP_ENV=production|DEBUG=false)$'" \
  --expect-exit-code 0 \
  --expect-stdout-contains "APP_ENV=production"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Container env-app started with correct environment variables."
