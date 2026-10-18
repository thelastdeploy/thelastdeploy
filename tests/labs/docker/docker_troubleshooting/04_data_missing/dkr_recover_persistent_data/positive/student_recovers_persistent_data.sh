#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Persistent Data
# Lab: dkr-recover-persistent-data
# ==============================================================================

# Step 1: Ensure directory and seed marker exist
student_exec \
  --step-name "Ensure directory and seed marker exist" \
  --cmd "mkdir -p ~/docker-troubleshooting/persistence/postgres_data && [ -f ~/docker-troubleshooting/persistence/postgres_data/marker.txt ] || echo 'RECOVERED_DATA_88' > ~/docker-troubleshooting/persistence/postgres_data/marker.txt" \
  --expect-exit-code 0

# Step 2: Write corrected docker-compose.yml
student_exec \
  --step-name "Write corrected docker-compose.yml" \
  --cmd "cat << 'EOF' > ~/docker-troubleshooting/persistence/docker-compose.yml
version: \"3.8\"

services:
  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_PASSWORD=secret
    volumes:
      - ./postgres_data:/var/lib/postgresql/data
EOF" \
  --expect-exit-code 0

# Step 3: Start compose stack in detached mode
student_exec \
  --step-name "Launch compose stack in detached mode" \
  --cmd "docker compose -f ~/docker-troubleshooting/persistence/docker-compose.yml up -d" \
  --expect-exit-code 0

# Step 4: Verify compose stack is running
student_exec \
  --step-name "Verify compose stack status" \
  --cmd "docker compose -f ~/docker-troubleshooting/persistence/docker-compose.yml ps" \
  --expect-exit-code 0 \
  --expect-stdout-contains "db"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully corrected mount mapping and restored persistent database folder."
