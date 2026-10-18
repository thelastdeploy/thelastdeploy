#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Finds Container IP Address
# Lab: dkr-find-container-config
# ==============================================================================

# Step 1: Ensure docker-test directory exists
student_exec \
  --step-name "Ensure docker-test directory exists" \
  --cmd "mkdir -p ~/docker-test" \
  --expect-exit-code 0

# Step 2: Extract container IP address
student_exec \
  --step-name "Extract container IP address" \
  --cmd "docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' config-target > ~/docker-test/container_ip.txt" \
  --expect-exit-code 0

# Step 3: Verify container_ip.txt content
student_exec \
  --step-name "Verify container_ip.txt content" \
  --cmd "cat ~/docker-test/container_ip.txt" \
  --expect-exit-code 0

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully inspected and saved container IP."
