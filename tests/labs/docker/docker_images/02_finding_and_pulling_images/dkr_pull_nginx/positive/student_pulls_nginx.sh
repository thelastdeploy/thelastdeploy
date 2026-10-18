#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Pulls Nginx Image
# Lab: dkr-pull-nginx
# ==============================================================================

# Step 1: Pull latest nginx image
student_exec \
  --step-name "Pull nginx image" \
  --cmd "docker pull nginx" \
  --expect-exit-code 0

# Step 2: Verify nginx:latest image exists locally
student_exec \
  --step-name "Verify nginx:latest image exists" \
  --cmd "docker image inspect nginx:latest" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully pulled nginx:latest image."
