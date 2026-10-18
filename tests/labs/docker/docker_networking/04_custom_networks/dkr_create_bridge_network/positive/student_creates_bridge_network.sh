#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Creates Bridge Network
# Lab: dkr-create-bridge-network
# ==============================================================================

# Step 1: Create user-defined bridge network
student_exec \
  --step-name "Create user-defined bridge network custom-bridge-net" \
  --cmd "docker network create --driver bridge custom-bridge-net" \
  --expect-exit-code 0

# Step 2: Verify network driver via docker inspect
student_exec \
  --step-name "Verify network driver is bridge" \
  --cmd "docker network inspect custom-bridge-net --format '{{.Driver}}'" \
  --expect-exit-code 0 \
  --expect-stdout-contains "bridge"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Bridge network created successfully."
