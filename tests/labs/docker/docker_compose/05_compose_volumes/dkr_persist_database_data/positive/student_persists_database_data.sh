#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Persists Database Data with Named Volumes
# Lab: dkr-persist-database-data
# ==============================================================================

# Step 1: Ensure directory exists
student_exec \
  --step-name "Ensure directory exists" \
  --cmd "mkdir -p ~/docker-compose/volumes" \
  --expect-exit-code 0

# Step 2: Write compose file with named volume
student_exec \
  --step-name "Write docker-compose.yml" \
  --cmd "cat << 'EOF' > ~/docker-compose/volumes/docker-compose.yml
version: \"3.8\"

services:
  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_PASSWORD=secret
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:
EOF" \
  --expect-exit-code 0

# Step 3: Start compose stack in detached mode
student_exec \
  --step-name "Launch compose stack in detached mode" \
  --cmd "docker compose -f ~/docker-compose/volumes/docker-compose.yml up -d" \
  --expect-exit-code 0

# Step 4: Verify compose stack is running
student_exec \
  --step-name "Verify compose stack status" \
  --cmd "docker compose -f ~/docker-compose/volumes/docker-compose.yml ps" \
  --expect-exit-code 0 \
  --expect-stdout-contains "db"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Persistent named volume configured correctly for database."
