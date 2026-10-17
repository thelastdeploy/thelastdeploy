#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Routing Table
# Lab: lnx-inspect-routing-table
# ==============================================================================

# Step 1: Ensure net-test directory exists
student_exec \
  --step-name "Ensure net-test directory exists" \
  --cmd "mkdir -p ~/net-test" \
  --expect-exit-code 0

# Step 2: Inspect routing routes simulation
student_exec \
  --step-name "Inspect routing rules" \
  --cmd "cat ~/net-test/routing/routes.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "192.168.1.1"

# Step 3: Write default gateway IP
student_exec \
  --step-name "Write default gateway IP" \
  --cmd "echo '192.168.1.1' > ~/net-test/default_gateway.txt" \
  --expect-exit-code 0

# Step 4: Verify content of default_gateway.txt
student_exec \
  --step-name "Verify default_gateway.txt content" \
  --cmd "cat ~/net-test/default_gateway.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "192.168.1.1"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SUCCESS: Default gateway identified successfully."
