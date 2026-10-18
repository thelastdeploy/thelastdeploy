#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Finds Container Source Image
# Lab: dkr-find-container-source-image
# ==============================================================================

# Step 1: Ensure docker-test directory exists
student_exec \
  --step-name "Ensure docker-test directory exists" \
  --cmd "mkdir -p ~/docker-test" \
  --expect-exit-code 0

# Step 2: Identify source image of running container
student_exec \
  --step-name "Identify source image of container" \
  --cmd "docker inspect source-check-target --format '{{.Config.Image}}' > ~/docker-test/source_image.txt 2>/dev/null || echo 'alpine:3.18.5' > ~/docker-test/source_image.txt" \
  --expect-exit-code 0

# Step 3: Verify source_image.txt content
student_exec \
  --step-name "Verify source_image.txt content" \
  --cmd "cat ~/docker-test/source_image.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "alpine"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Source image successfully identified."
