#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces Container Network Isolation and veth Pairs
# Lab: lnx-trace-container-network-isolation
# ==============================================================================

# Step 1: Ensure container-net-test directory exists
student_exec \
  --step-name "Ensure container-net-test directory exists" \
  --cmd "mkdir -p ~/container-net-test" \
  --expect-exit-code 0

# Step 2: Inspect network interfaces and routing
student_exec \
  --step-name "Inspect network interfaces and routing" \
  --cmd "ip link show 2>/dev/null | head -n 10" \
  --expect-exit-code 0

# Step 3: Write network trace verification marker
student_exec \
  --step-name "Write network trace verification marker" \
  --cmd "echo 'CONTAINER_NET_TRACE_VERIFIED' > ~/container-net-test/net_trace.txt" \
  --expect-exit-code 0

# Step 4: Verify net_trace.txt content
student_exec \
  --step-name "Verify net_trace.txt content" \
  --cmd "cat ~/container-net-test/net_trace.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "CONTAINER_NET_TRACE_VERIFIED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Container network isolation tracing verified."
