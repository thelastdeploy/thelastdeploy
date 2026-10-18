#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Fixes File Inside Container
# Lab: dkr-fix-file-inside-container
# ==============================================================================

# Step 1: Update configuration file inside container
student_exec \
  --step-name "Update configuration file inside container" \
  --cmd "docker exec app-to-fix sh -c 'echo \"STATUS=fixed\" > /app/config.txt'" \
  --expect-exit-code 0

# Step 2: Verify configuration file contents inside container
student_exec \
  --step-name "Verify configuration file contents inside container" \
  --cmd "docker exec app-to-fix cat /app/config.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "STATUS=fixed"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully fixed configuration file inside running container."
