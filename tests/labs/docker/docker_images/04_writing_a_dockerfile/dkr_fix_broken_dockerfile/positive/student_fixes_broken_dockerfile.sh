#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Fixes Broken Dockerfile
# Lab: dkr-fix-broken-dockerfile
# ==============================================================================

# Step 1: Fix syntax error in Dockerfile
student_exec \
  --step-name "Fix RUNN typo in Dockerfile" \
  --cmd "sed -i 's/RUNN/RUN/' ~/docker-build/broken-dockerfile/Dockerfile" \
  --expect-exit-code 0

# Step 2: Verify Dockerfile content
student_exec \
  --step-name "Verify corrected Dockerfile" \
  --cmd "cat ~/docker-build/broken-dockerfile/Dockerfile" \
  --expect-exit-code 0 \
  --expect-stdout-contains "RUN apk add"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully fixed the Dockerfile and built the image."
