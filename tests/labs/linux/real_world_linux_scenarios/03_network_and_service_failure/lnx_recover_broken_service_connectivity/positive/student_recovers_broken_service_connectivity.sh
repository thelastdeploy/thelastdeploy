#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Broken Service Connectivity
# Lab: lnx-recover-broken-service-connectivity
# ==============================================================================

# Step 1: Ensure net-failure directory exists
student_exec \
  --step-name "Ensure net-failure directory exists" \
  --cmd "mkdir -p ~/net-failure" \
  --expect-exit-code 0

# Step 2: Check network configuration
student_exec \
  --step-name "Check network configuration" \
  --cmd "ip addr show && ip route show" \
  --expect-exit-code 0

# Step 3: Write connectivity restoration marker
student_exec \
  --step-name "Write connectivity restoration marker" \
  --cmd "echo 'SERVICE_NETWORK_CONNECTIVITY_RESTORED' > ~/net-failure/connectivity_recovery.log" \
  --expect-exit-code 0

# Step 4: Verify recovery log content
student_exec \
  --step-name "Verify recovery log content" \
  --cmd "cat ~/net-failure/connectivity_recovery.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SERVICE_NETWORK_CONNECTIVITY_RESTORED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Recover Broken Service Connectivity verified successfully."
