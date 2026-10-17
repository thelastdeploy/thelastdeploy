#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Network State
# Lab: lnx-inspect-network-state
# ==============================================================================

# Step 1: Ensure net-test directory exists
student_exec \
  --step-name "Ensure net-test directory exists" \
  --cmd "mkdir -p ~/net-test" \
  --expect-exit-code 0

# Step 2: Inspect network interfaces via ip addr
student_exec \
  --step-name "Inspect network interfaces" \
  --cmd "ip addr" \
  --expect-exit-code 0

# Step 3: Write loopback IP address
student_exec \
  --step-name "Write loopback IP address" \
  --cmd "echo '127.0.0.1' > ~/net-test/loopback.txt" \
  --expect-exit-code 0

# Step 4: Verify content of loopback.txt
student_exec \
  --step-name "Verify loopback.txt content" \
  --cmd "cat ~/net-test/loopback.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "127.0.0.1"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SUCCESS: Network state inspected correctly."
