#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Creates Compose File
# Lab: dkr-create-compose-file
# ==============================================================================

# Step 1: Ensure directory exists
student_exec \
  --step-name "Ensure directory exists" \
  --cmd "mkdir -p ~/docker-compose/first-compose" \
  --expect-exit-code 0

# Step 2: Write docker-compose.yml
student_exec \
  --step-name "Write docker-compose.yml configuration" \
  --cmd "cat << 'EOF' > ~/docker-compose/first-compose/docker-compose.yml
version: \"3.8\"
services:
  web:
    image: nginx:alpine
    ports:
      - \"8080:80\"
EOF" \
  --expect-exit-code 0

# Step 3: Verify compose file content
student_exec \
  --step-name "Verify compose file content" \
  --cmd "cat ~/docker-compose/first-compose/docker-compose.yml" \
  --expect-exit-code 0 \
  --expect-stdout-contains "8080:80"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully validated docker-compose.yml configuration."
