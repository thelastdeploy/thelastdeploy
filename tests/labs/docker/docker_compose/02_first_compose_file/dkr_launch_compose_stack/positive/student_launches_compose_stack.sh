#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Launches Compose Stack
# Lab: dkr-launch-compose-stack
# ==============================================================================

# Step 1: Start compose stack in detached mode
student_exec \
  --step-name "Launch compose stack in detached mode" \
  --cmd "docker compose -f ~/docker-compose/first-compose/docker-compose.yml up -d" \
  --expect-exit-code 0

# Step 2: Verify service is reachable on port 8080
student_exec \
  --step-name "Verify service is reachable" \
  --cmd "curl -s http://localhost:8080" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Welcome to nginx"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Compose stack is up and running Nginx on port 8080."
