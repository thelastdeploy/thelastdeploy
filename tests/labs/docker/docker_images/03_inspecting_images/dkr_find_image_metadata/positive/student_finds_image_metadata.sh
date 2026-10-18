#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Finds Image Metadata
# Lab: dkr-find-image-metadata
# ==============================================================================

# Step 1: Ensure docker-test directory exists
student_exec \
  --step-name "Ensure docker-test directory exists" \
  --cmd "mkdir -p ~/docker-test" \
  --expect-exit-code 0

# Step 2: Extract architecture metadata from alpine:3.18.5
student_exec \
  --step-name "Extract architecture metadata" \
  --cmd "docker image inspect -f '{{.Architecture}}' alpine:3.18.5 > ~/docker-test/image_arch.txt" \
  --expect-exit-code 0

# Step 3: Verify image_arch.txt content
student_exec \
  --step-name "Verify image_arch.txt content" \
  --cmd "cat ~/docker-test/image_arch.txt" \
  --expect-exit-code 0

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully extracted image architecture metadata."
