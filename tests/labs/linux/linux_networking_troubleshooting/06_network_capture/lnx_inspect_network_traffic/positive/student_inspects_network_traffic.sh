#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Network Traffic
# Lab: lnx-inspect-network-traffic
# ==============================================================================

# Step 1: Ensure net-test directory exists
student_exec \
  --step-name "Ensure net-test directory exists" \
  --cmd "mkdir -p ~/net-test" \
  --expect-exit-code 0

# Step 2: Inspect simulated tcpdump log
student_exec \
  --step-name "Inspect tcpdump log" \
  --cmd "cat ~/net-test/capture/tcpdump.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "192.168.1.50"

# Step 3: Write client IP address
student_exec \
  --step-name "Write client source IP" \
  --cmd "echo '192.168.1.50' > ~/net-test/client_ip.txt" \
  --expect-exit-code 0

# Step 4: Verify content of client_ip.txt
student_exec \
  --step-name "Verify client_ip.txt content" \
  --cmd "cat ~/net-test/client_ip.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "192.168.1.50"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SUCCESS: Network capture log inspected and source IP verified."
