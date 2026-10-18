#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Restores Service Connectivity
# Lab: dkr-restore-service-connectivity
# ==============================================================================

# Step 1: Ensure directory exists
student_exec \
  --step-name "Ensure directory exists" \
  --cmd "mkdir -p ~/docker-troubleshooting/connectivity" \
  --expect-exit-code 0

# Step 2: Write compose file connecting both services to shared network
student_exec \
  --step-name "Write updated docker-compose.yml" \
  --cmd "cat << 'EOF' > ~/docker-troubleshooting/connectivity/docker-compose.yml
version: \"3.8\"

services:
  web:
    image: nginx:alpine
    ports:
      - 8085:80
    networks:
      - app-net

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_PASSWORD=secret
    networks:
      - app-net

networks:
  app-net:
EOF" \
  --expect-exit-code 0

# Step 3: Start compose stack in detached mode
student_exec \
  --step-name "Launch compose stack in detached mode" \
  --cmd "docker compose -f ~/docker-troubleshooting/connectivity/docker-compose.yml up -d" \
  --expect-exit-code 0

# Step 4: Verify compose stack is running
student_exec \
  --step-name "Verify compose stack status" \
  --cmd "docker compose -f ~/docker-troubleshooting/connectivity/docker-compose.yml ps" \
  --expect-exit-code 0 \
  --expect-stdout-contains "web"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Restored network connectivity by placing both containers on a shared network."
