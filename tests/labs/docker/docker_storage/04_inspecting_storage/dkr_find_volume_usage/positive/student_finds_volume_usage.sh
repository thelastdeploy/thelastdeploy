#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Finds Volume Usage
# Lab: dkr-find-volume-usage
# ==============================================================================

# Step 1: Ensure destination directory exists
student_exec \
  --step-name "Ensure ~/docker-test directory exists" \
  --cmd "mkdir -p ~/docker-test" \
  --expect-exit-code 0

# Step 2: Extract volume mount destination via docker inspect
student_exec \
  --step-name "Extract volume mount destination" \
  --cmd "docker inspect --format '{{range .Mounts}}{{if eq .Name \"analytics-vol\"}}{{.Destination}}{{end}}{{end}}' analytics-app > ~/docker-test/volume_destination.txt" \
  --expect-exit-code 0

# Step 3: Verify destination file content
student_exec \
  --step-name "Verify destination file content" \
  --cmd "cat ~/docker-test/volume_destination.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "/var/log/analytics"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully verified volume destination inspection."
