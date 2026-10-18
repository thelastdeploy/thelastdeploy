#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Configures Environment Variables via .env
# Lab: dkr-fix-env-configuration
# ==============================================================================

# Step 1: Ensure directory exists
student_exec \
  --step-name "Ensure directory exists" \
  --cmd "mkdir -p ~/docker-compose/env-vars" \
  --expect-exit-code 0

# Step 2: Ensure docker-compose.yml exists
student_exec \
  --step-name "Ensure docker-compose.yml is present" \
  --cmd "cat << 'EOF' > ~/docker-compose/env-vars/docker-compose.yml
version: \"3.8\"
services:
  app:
    image: alpine
    command: sh -c \"echo App password is \\\$\$DB_PASSWORD && sleep 3600\"
    environment:
      - DB_PASSWORD=\${DB_PASSWORD}
  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=\${DB_PASSWORD}
      - POSTGRES_DB=app_db
EOF" \
  --expect-exit-code 0

# Step 3: Create .env file with required DB_PASSWORD
student_exec \
  --step-name "Create .env configuration file" \
  --cmd "echo 'DB_PASSWORD=supersecure123' > ~/docker-compose/env-vars/.env" \
  --expect-exit-code 0

# Step 4: Start compose stack in detached mode
student_exec \
  --step-name "Launch compose stack in detached mode" \
  --cmd "docker compose -f ~/docker-compose/env-vars/docker-compose.yml up -d" \
  --expect-exit-code 0

# Step 5: Verify compose stack is running
student_exec \
  --step-name "Verify compose stack status" \
  --cmd "docker compose -f ~/docker-compose/env-vars/docker-compose.yml ps" \
  --expect-exit-code 0 \
  --expect-stdout-contains "app"

# Step 6: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully configured stack environment using .env file."
