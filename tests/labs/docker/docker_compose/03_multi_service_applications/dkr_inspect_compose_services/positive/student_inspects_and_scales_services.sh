#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects and Scales Services
# Lab: dkr-inspect-compose-services
# ==============================================================================

# Step 1: Scale web service to 2 instances
student_exec \
  --step-name "Scale web service to 2 instances" \
  --cmd "docker compose -f ~/docker-compose/multi-service/docker-compose.yml up -d --scale web=2" \
  --expect-exit-code 0

# Step 2: Verify 2 web containers are running
student_exec \
  --step-name "Verify 2 web containers are running" \
  --cmd "docker ps --filter \"label=com.docker.compose.project=multi-service\" --filter \"label=com.docker.compose.service=web\" --filter \"status=running\" -q | wc -l" \
  --expect-exit-code 0 \
  --expect-stdout-contains "2"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully scaled service 'web' to 2 instances."
