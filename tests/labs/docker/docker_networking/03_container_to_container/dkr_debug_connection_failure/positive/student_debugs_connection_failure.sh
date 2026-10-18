#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Debugs Connection Failure
# Lab: dkr-debug-connection-failure
# ==============================================================================

# Step 1: Connect client-app to debug-net network
student_exec \
  --step-name "Connect client-app to debug-net network" \
  --cmd "docker network connect debug-net client-app" \
  --expect-exit-code 0

# Step 2: Ensure destination directory exists
student_exec \
  --step-name "Ensure ~/docker-test directory exists" \
  --cmd "mkdir -p ~/docker-test" \
  --expect-exit-code 0

# Step 3: Fetch webpage from backend-service via client-app
student_exec \
  --step-name "Fetch webpage from backend-service" \
  --cmd "docker exec client-app curl -s http://backend-service > ~/docker-test/debug_output.txt" \
  --expect-exit-code 0

# Step 4: Verify debug output file content
student_exec \
  --step-name "Verify debug output file content" \
  --cmd "cat ~/docker-test/debug_output.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Welcome to nginx!"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully debugged network connection and linked containers."
