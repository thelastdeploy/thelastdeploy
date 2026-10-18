#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Accesses Web Container
# Lab: dkr-access-web-container
# ==============================================================================

# Step 1: Ensure docker-test directory exists
student_exec \
  --step-name "Ensure docker-test directory exists" \
  --cmd "mkdir -p ~/docker-test" \
  --expect-exit-code 0

# Step 2: Query web container HTTP response code
student_exec \
  --step-name "Query web container response code" \
  --cmd "curl -s -o /dev/null -w '%{http_code}' http://localhost:8082 > ~/docker-test/web_status.txt" \
  --expect-exit-code 0

# Step 3: Verify web_status.txt content
student_exec \
  --step-name "Verify web_status.txt content" \
  --cmd "cat ~/docker-test/web_status.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "200"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully queried the web container and saved the response code."
