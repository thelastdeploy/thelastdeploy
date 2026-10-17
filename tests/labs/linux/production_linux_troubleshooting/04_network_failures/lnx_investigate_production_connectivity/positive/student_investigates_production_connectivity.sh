#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Production Network Connectivity Failure
# Lab: lnx-investigate-production-connectivity
# ==============================================================================

# Step 1: Ensure net-outage-test directory exists
student_exec \
  --step-name "Ensure net-outage-test directory exists" \
  --cmd "mkdir -p ~/net-outage-test" \
  --expect-exit-code 0

# Step 2: Inspect listening network sockets
student_exec \
  --step-name "Inspect listening network sockets" \
  --cmd "ss -tulpn | head -n 10 || true" \
  --expect-exit-code 0

# Step 3: Write network failure diagnosis marker
student_exec \
  --step-name "Write network failure diagnosis marker" \
  --cmd "echo 'NETWORK_CONNECTIVITY_FAILURE_DIAGNOSED' > ~/net-outage-test/net_diag.txt" \
  --expect-exit-code 0

# Step 4: Verify net_diag.txt content
student_exec \
  --step-name "Verify net_diag.txt content" \
  --cmd "cat ~/net-outage-test/net_diag.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "NETWORK_CONNECTIVITY_FAILURE_DIAGNOSED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Production network connectivity failure investigation verified."
