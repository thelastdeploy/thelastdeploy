#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Runs Nginx Container
# Lab: dkr-run-nginx
# ==============================================================================

# Step 1: Clean any existing container
student_exec \
  --step-name "Clean existing container" \
  --cmd "docker rm -f my-nginx-server 2>/dev/null || true" \
  --expect-exit-code 0

# Step 2: Run nginx container with port mapping 8085:80
student_exec \
  --step-name "Run nginx container on port 8085" \
  --cmd "docker run -d --name my-nginx-server -p 8085:80 nginx:alpine" \
  --expect-exit-code 0

# Step 3: Verify container running
student_exec \
  --step-name "Verify container is running" \
  --cmd "docker inspect my-nginx-server --format '{{.State.Running}}'" \
  --expect-exit-code 0 \
  --expect-stdout-contains "true"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Nginx container started on port 8085 successfully."
