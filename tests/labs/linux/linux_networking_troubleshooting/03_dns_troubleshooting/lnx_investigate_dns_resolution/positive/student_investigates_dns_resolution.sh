#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates DNS Resolution
# Lab: lnx-investigate-dns-resolution
# ==============================================================================

# Step 1: Ensure net-test directory exists
student_exec \
  --step-name "Ensure net-test directory exists" \
  --cmd "mkdir -p ~/net-test" \
  --expect-exit-code 0

# Step 2: Inspect DNS query log
student_exec \
  --step-name "Inspect DNS query log" \
  --cmd "cat ~/net-test/dns/dig_output.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "10.250.0.15"

# Step 3: Write resolved IP address
student_exec \
  --step-name "Write resolved IP" \
  --cmd "echo '10.250.0.15' > ~/net-test/resolved_ip.txt" \
  --expect-exit-code 0

# Step 4: Verify content of resolved_ip.txt
student_exec \
  --step-name "Verify resolved_ip.txt content" \
  --cmd "cat ~/net-test/resolved_ip.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "10.250.0.15"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SUCCESS: DNS resolution query audited successfully."
