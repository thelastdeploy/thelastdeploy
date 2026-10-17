#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Debugs Advanced Network Service Binding
# Lab: lnx-debug-advanced-network-service
# ==============================================================================

# Step 1: Ensure svc-net-test directory exists
student_exec \
  --step-name "Ensure svc-net-test directory exists" \
  --cmd "mkdir -p ~/svc-net-test" \
  --expect-exit-code 0

# Step 2: Inspect network socket bindings
student_exec \
  --step-name "Inspect network socket bindings" \
  --cmd "ss -tun" \
  --expect-exit-code 0

# Step 3: Write socket bindings summary
student_exec \
  --step-name "Write socket bindings summary" \
  --cmd "echo 'SOCKET_BINDINGS_INSPECTED' > ~/svc-net-test/sockets.txt" \
  --expect-exit-code 0

# Step 4: Verify content of sockets.txt
student_exec \
  --step-name "Verify sockets.txt content" \
  --cmd "cat ~/svc-net-test/sockets.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SOCKET_BINDINGS_INSPECTED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Network service socket binding debug verified."
