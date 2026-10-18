#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Runs Web and Database Services
# Lab: dkr-run-web-and-db
# ==============================================================================

# Step 1: Ensure directory exists
student_exec \
  --step-name "Ensure directory exists" \
  --cmd "mkdir -p ~/docker-compose/multi-service" \
  --expect-exit-code 0

# Step 2: Write multi-service docker-compose.yml
student_exec \
  --step-name "Write docker-compose.yml" \
  --cmd "cat << 'EOF' > ~/docker-compose/multi-service/docker-compose.yml
version: \"3.8\"
services:
  web:
    image: nginx:alpine
    ports:
      - \"8081:80\"
  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=admin
      - POSTGRES_PASSWORD=secret
      - POSTGRES_DB=mydb
EOF" \
  --expect-exit-code 0

# Step 3: Start multi-service compose stack in detached mode
student_exec \
  --step-name "Launch compose stack in detached mode" \
  --cmd "docker compose -f ~/docker-compose/multi-service/docker-compose.yml up -d" \
  --expect-exit-code 0

# Step 4: Verify web service response
student_exec \
  --step-name "Verify web service response on port 8081" \
  --cmd "curl -s http://localhost:8081" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Welcome to nginx"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Multi-service stack running web on 8081 and db with correct credentials."
