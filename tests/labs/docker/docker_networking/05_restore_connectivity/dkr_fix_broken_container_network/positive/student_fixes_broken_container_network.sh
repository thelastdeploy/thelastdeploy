#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Fixes Broken Container Network
# Lab: dkr-fix-broken-container-network
# ==============================================================================

# Step 1: Disconnect container from none network
student_exec \
  --step-name "Disconnect broken-web from none" \
  --cmd "docker network disconnect none broken-web" \
  --expect-exit-code 0

# Step 2: Connect container to web-net custom network
student_exec \
  --step-name "Connect broken-web to web-net" \
  --cmd "docker network connect web-net broken-web" \
  --expect-exit-code 0

# Step 3: Verify container is attached to web-net
student_exec \
  --step-name "Verify container networks" \
  --cmd "docker inspect broken-web --format '{{range \$k, \$v := .NetworkSettings.Networks}}{{\$k}} {{end}}'" \
  --expect-exit-code 0 \
  --expect-stdout-contains "web-net"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Restored network connectivity successfully."
