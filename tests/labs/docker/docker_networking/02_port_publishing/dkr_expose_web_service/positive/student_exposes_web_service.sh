#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Exposes Web Service
# Lab: dkr-expose-web-service
# ==============================================================================

# Step 1: Start container with published port 8088:80
student_exec \
  --step-name "Start web-service container with port 8088:80" \
  --cmd "docker run -d --name web-service -p 8088:80 nginx:alpine" \
  --expect-exit-code 0

# Step 2: Verify site is reachable on port 8088
student_exec \
  --step-name "Verify site is reachable on port 8088" \
  --cmd "curl -s http://localhost:8088" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Welcome to nginx"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Web service exposed successfully on port 8088."
