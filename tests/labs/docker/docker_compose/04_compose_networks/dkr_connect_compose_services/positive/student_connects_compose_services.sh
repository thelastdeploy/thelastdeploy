#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Connects Compose Services via Networks
# Lab: dkr-connect-compose-services
# ==============================================================================

# Step 1: Ensure directory exists
student_exec \
  --step-name "Ensure directory exists" \
  --cmd "mkdir -p ~/docker-compose/networks" \
  --expect-exit-code 0

# Step 2: Write compose file with isolated networks
student_exec \
  --step-name "Write docker-compose.yml" \
  --cmd "cat << 'EOF' > ~/docker-compose/networks/docker-compose.yml
version: \"3.8\"

services:
  web:
    image: nginx:alpine
    networks:
      - frontend-net
    ports:
      - \"8082:80\"

  api:
    image: nginx:alpine
    networks:
      - frontend-net
      - backend-net

  db:
    image: postgres:15-alpine
    networks:
      - backend-net
    environment:
      - POSTGRES_PASSWORD=secret

networks:
  frontend-net:
  backend-net:
EOF" \
  --expect-exit-code 0

# Step 3: Start compose stack in detached mode
student_exec \
  --step-name "Launch compose stack in detached mode" \
  --cmd "docker compose -f ~/docker-compose/networks/docker-compose.yml up -d" \
  --expect-exit-code 0

# Step 4: Verify compose stack is running
student_exec \
  --step-name "Verify compose stack status" \
  --cmd "docker compose -f ~/docker-compose/networks/docker-compose.yml ps" \
  --expect-exit-code 0 \
  --expect-stdout-contains "web"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Network isolation verified between web, api, and db."
