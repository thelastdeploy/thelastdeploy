#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Connects Two Containers
# Lab: dkr-connect-two-containers
# ==============================================================================

# Step 1: Ensure destination directory exists
student_exec \
  --step-name "Ensure ~/docker-test directory exists" \
  --cmd "mkdir -p ~/docker-test" \
  --expect-exit-code 0

# Step 2: Fetch page from server-target via client-source
student_exec \
  --step-name "Fetch webpage via custom network DNS name" \
  --cmd "docker exec client-source curl -s http://server-target > ~/docker-test/fetched_page.txt" \
  --expect-exit-code 0

# Step 3: Verify fetched content
student_exec \
  --step-name "Verify fetched page content" \
  --cmd "cat ~/docker-test/fetched_page.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Welcome to nginx!"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Containers successfully communicated via custom network DNS resolution."
