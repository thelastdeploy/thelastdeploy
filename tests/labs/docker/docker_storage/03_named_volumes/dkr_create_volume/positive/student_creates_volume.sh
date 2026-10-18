#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Creates Named Volume
# Lab: dkr-create-volume
# ==============================================================================

# Step 1: Create named volume
student_exec \
  --step-name "Create named volume app-data-vol" \
  --cmd "docker volume create app-data-vol" \
  --expect-exit-code 0

# Step 2: Verify volume exists via docker volume inspect
student_exec \
  --step-name "Verify volume exists" \
  --cmd "docker volume inspect app-data-vol" \
  --expect-exit-code 0 \
  --expect-stdout-contains "app-data-vol"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully created named volume 'app-data-vol'."
