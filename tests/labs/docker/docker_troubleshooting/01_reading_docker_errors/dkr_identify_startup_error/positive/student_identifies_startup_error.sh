#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Identifies Container Startup Error
# Lab: dkr-identify-startup-error
# ==============================================================================

# Step 1: Ensure errors directory exists
student_exec \
  --step-name "Ensure errors directory exists" \
  --cmd "mkdir -p ~/docker-troubleshooting/errors" \
  --expect-exit-code 0

# Step 2: Ensure crashing container exists
student_exec \
  --step-name "Ensure crashing container exists" \
  --cmd "docker rm -f crashing-app || true; docker run -d --name crashing-app alpine sh -c 'echo ERROR: Initialization failed. Code: ERR_TOKEN_XY123 >&2 && exit 1' || true" \
  --expect-exit-code 0

# Step 3: Inspect container logs
student_exec \
  --step-name "Inspect container logs" \
  --cmd "docker logs crashing-app" \
  --expect-exit-code 0 \
  --expect-stderr-contains "ERR_TOKEN_XY123"

# Step 4: Extract error token to target file
student_exec \
  --step-name "Save startup token to file" \
  --cmd "echo 'ERR_TOKEN_XY123' > ~/docker-troubleshooting/errors/startup-token.txt" \
  --expect-exit-code 0

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully extracted the startup error token!"
