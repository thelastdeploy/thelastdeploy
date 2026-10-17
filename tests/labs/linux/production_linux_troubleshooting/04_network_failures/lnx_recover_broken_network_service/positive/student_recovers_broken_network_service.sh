#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Broken Network Service
# Lab: lnx-recover-broken-network-service
# ==============================================================================

# Step 1: Ensure net-outage-test directory exists
student_exec \
  --step-name "Ensure net-outage-test directory exists" \
  --cmd "mkdir -p ~/net-outage-test" \
  --expect-exit-code 0

# Step 2: Test network route and interface status
student_exec \
  --step-name "Test network route and interface status" \
  --cmd "ip route show || true" \
  --expect-exit-code 0

# Step 3: Write network recovery proof marker
student_exec \
  --step-name "Write network recovery proof marker" \
  --cmd "echo 'BROKEN_NETWORK_SERVICE_RECOVERED' > ~/net-outage-test/net_recovered.txt" \
  --expect-exit-code 0

# Step 4: Verify net_recovered.txt content
student_exec \
  --step-name "Verify net_recovered.txt content" \
  --cmd "cat ~/net-outage-test/net_recovered.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "BROKEN_NETWORK_SERVICE_RECOVERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Broken network service recovery verified."
