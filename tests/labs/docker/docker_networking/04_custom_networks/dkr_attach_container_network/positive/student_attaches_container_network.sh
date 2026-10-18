#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Attaches Container to Network
# Lab: dkr-attach-container-network
# ==============================================================================

# Step 1: Connect container to custom network
student_exec \
  --step-name "Connect isolated-app to production-net" \
  --cmd "docker network connect production-net isolated-app" \
  --expect-exit-code 0

# Step 2: Verify container is attached to network
student_exec \
  --step-name "Verify container networks" \
  --cmd "docker inspect isolated-app --format '{{range \$k, \$v := .NetworkSettings.Networks}}{{\$k}} {{end}}'" \
  --expect-exit-code 0 \
  --expect-stdout-contains "production-net"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Container successfully attached to custom network."
