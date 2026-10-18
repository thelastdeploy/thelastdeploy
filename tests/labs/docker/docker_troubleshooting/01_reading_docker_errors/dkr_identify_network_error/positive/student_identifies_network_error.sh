#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Identifies Container Network Error
# Lab: dkr-identify-network-error
# ==============================================================================

# Step 1: Ensure errors directory exists
student_exec \
  --step-name "Ensure errors directory exists" \
  --cmd "mkdir -p ~/docker-troubleshooting/errors" \
  --expect-exit-code 0

# Step 2: Ensure failed client container exists
student_exec \
  --step-name "Ensure failed client container exists" \
  --cmd "docker rm -f api-client || true; docker run -d --name api-client alpine sh -c 'echo Connecting to api-server on port 9999... && echo Error: dial tcp 127.0.0.1:9999: connect: connection refused >&2 && exit 1' || true" \
  --expect-exit-code 0

# Step 3: Inspect container logs
student_exec \
  --step-name "Inspect container logs" \
  --cmd "docker logs api-client" \
  --expect-exit-code 0 \
  --expect-stderr-contains "9999"

# Step 4: Extract port number to target file
student_exec \
  --step-name "Save network port to file" \
  --cmd "echo '9999' > ~/docker-troubleshooting/errors/network-port.txt" \
  --expect-exit-code 0

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully extracted the network failure port!"
