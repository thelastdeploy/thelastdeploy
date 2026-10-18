#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Shares Host Directory
# Lab: dkr-share-host-directory
# ==============================================================================

# Step 1: Start Nginx container with bind mount and port mapping
student_exec \
  --step-name "Start nginx-mount container with bind mount" \
  --cmd "docker run -d --name nginx-mount -p 8085:80 -v \"\$HOME/docker-share:/usr/share/nginx/html\" nginx:alpine" \
  --expect-exit-code 0

# Step 2: Verify site response via curl
student_exec \
  --step-name "Verify site response via curl" \
  --cmd "curl -s http://localhost:8085" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Welcome to Bind Mounts"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully mounted host directory to Nginx container."
