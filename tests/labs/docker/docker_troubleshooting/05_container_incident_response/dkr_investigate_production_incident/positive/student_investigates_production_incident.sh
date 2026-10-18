#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Production Incident
# Lab: dkr-investigate-production-incident
# ==============================================================================

# Step 1: Ensure directory exists
student_exec \
  --step-name "Ensure directory exists" \
  --cmd "mkdir -p ~/docker-troubleshooting/incident" \
  --expect-exit-code 0

# Step 2: Create config.json file
student_exec \
  --step-name "Create config.json file" \
  --cmd "echo '{\"status\": \"ok\"}' > ~/docker-troubleshooting/incident/config.json" \
  --expect-exit-code 0

# Step 3: Write updated docker-compose.yml with mount
student_exec \
  --step-name "Write updated docker-compose.yml" \
  --cmd "cat << 'EOF' > ~/docker-troubleshooting/incident/docker-compose.yml
version: \"3.8\"
services:
  app:
    image: alpine
    command: sh -c \"if [ ! -f /etc/app/config.json ]; then echo FATAL - config.json not found at /etc/app/config.json >&2 && exit 1; else echo App running... && sleep 3600; fi\"
    volumes:
      - ./config.json:/etc/app/config.json
EOF" \
  --expect-exit-code 0

# Step 4: Start compose stack in detached mode
student_exec \
  --step-name "Launch compose stack in detached mode" \
  --cmd "docker compose -f ~/docker-troubleshooting/incident/docker-compose.yml up -d" \
  --expect-exit-code 0

# Step 5: Verify compose stack is running
student_exec \
  --step-name "Verify compose stack status" \
  --cmd "docker compose -f ~/docker-troubleshooting/incident/docker-compose.yml ps" \
  --expect-exit-code 0 \
  --expect-stdout-contains "app"

# Step 6: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully mounted config.json and resolved application crash loop!"
