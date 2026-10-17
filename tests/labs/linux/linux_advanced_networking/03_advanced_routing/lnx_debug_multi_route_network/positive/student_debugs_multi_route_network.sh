#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Debugs Multi-Route Network Configuration
# Lab: lnx-debug-multi-route-network
# ==============================================================================

# Step 1: Ensure route-test directory exists
student_exec \
  --step-name "Ensure route-test directory exists" \
  --cmd "mkdir -p ~/route-test" \
  --expect-exit-code 0

# Step 2: Perform route lookup test
student_exec \
  --step-name "Perform route lookup test" \
  --cmd "ip route get 127.0.0.1" \
  --expect-exit-code 0

# Step 3: Write route debug output line
student_exec \
  --step-name "Write route debug output" \
  --cmd "echo 'ROUTE_LOOKUP_SUCCESS: 127.0.0.1' > ~/route-test/route_debug.txt" \
  --expect-exit-code 0

# Step 4: Verify content of route_debug.txt
student_exec \
  --step-name "Verify route_debug.txt content" \
  --cmd "cat ~/route-test/route_debug.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "ROUTE_LOOKUP_SUCCESS: 127.0.0.1"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Multi-route network debug verified."
