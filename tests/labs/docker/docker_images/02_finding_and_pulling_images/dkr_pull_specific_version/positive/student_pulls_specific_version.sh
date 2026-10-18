#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Pulls Specific Version
# Lab: dkr-pull-specific-version
# ==============================================================================

# Step 1: Pull pinned nginx 1.21.6 image
student_exec \
  --step-name "Pull nginx 1.21.6 image" \
  --cmd "docker pull nginx:1.21.6" \
  --expect-exit-code 0

# Step 2: Verify nginx:1.21.6 image exists locally
student_exec \
  --step-name "Verify nginx:1.21.6 image exists" \
  --cmd "docker image inspect nginx:1.21.6" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully pulled nginx:1.21.6 image."
