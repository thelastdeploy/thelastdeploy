#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Builds Custom Image
# Lab: dkr-build-custom-image
# ==============================================================================

# Step 1: Build Docker image tagged as my-custom-app:v1.0
student_exec \
  --step-name "Build Docker image" \
  --cmd "docker build -t my-custom-app:v1.0 ~/docker-build/custom-app" \
  --expect-exit-code 0

# Step 2: Verify image exists locally
student_exec \
  --step-name "Verify image exists" \
  --cmd "docker image inspect my-custom-app:v1.0" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully built custom image 'my-custom-app:v1.0'."
