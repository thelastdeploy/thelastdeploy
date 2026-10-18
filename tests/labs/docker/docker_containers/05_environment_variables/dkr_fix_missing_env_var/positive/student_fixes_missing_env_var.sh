#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Fixes Missing Environment Variable
# Lab: dkr-fix-missing-env-var
# ==============================================================================

# Step 1: Start container with required environment variable
student_exec \
  --step-name "Start db-connector container with DB_HOST" \
  --cmd "docker run -d --name db-connector -e DB_HOST=database.internal alpine sleep 1000" \
  --expect-exit-code 0

# Step 2: Verify environment variable inside container
student_exec \
  --step-name "Verify DB_HOST environment variable inside container" \
  --cmd "docker exec db-connector env | grep '^DB_HOST=database.internal$'" \
  --expect-exit-code 0 \
  --expect-stdout-contains "DB_HOST=database.internal"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Environment variable correctly configured."
