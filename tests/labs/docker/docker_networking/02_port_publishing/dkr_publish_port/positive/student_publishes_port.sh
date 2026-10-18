#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Publishes Port on Localhost
# Lab: dkr-publish-port
# ==============================================================================

# Step 1: Start container bound to loopback IP 127.0.0.1:8089:80
student_exec \
  --step-name "Start static-web container bound to 127.0.0.1:8089:80" \
  --cmd "docker run -d --name static-web -p 127.0.0.1:8089:80 nginx:alpine" \
  --expect-exit-code 0

# Step 2: Verify site is reachable on loopback port 8089
student_exec \
  --step-name "Verify site is reachable on loopback port 8089" \
  --cmd "curl -s http://127.0.0.1:8089" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Welcome to nginx"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully published port on loopback interface."
