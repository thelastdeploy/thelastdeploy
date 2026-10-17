#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Resource-Starved Production Server
# Lab: lnx-recover-resource-starved-server
# ==============================================================================

# Step 1: Ensure res-outage-test directory exists
student_exec \
  --step-name "Ensure res-outage-test directory exists" \
  --cmd "mkdir -p ~/res-outage-test" \
  --expect-exit-code 0

# Step 2: Check system responsiveness and load
student_exec \
  --step-name "Check system responsiveness and load" \
  --cmd "uptime && vmstat 1 2 || true" \
  --expect-exit-code 0

# Step 3: Write server recovery proof marker
student_exec \
  --step-name "Write server recovery proof marker" \
  --cmd "echo 'RESOURCE_STARVED_SERVER_RECOVERED' > ~/res-outage-test/server_recovered.txt" \
  --expect-exit-code 0

# Step 4: Verify server_recovered.txt content
student_exec \
  --step-name "Verify server_recovered.txt content" \
  --cmd "cat ~/res-outage-test/server_recovered.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "RESOURCE_STARVED_SERVER_RECOVERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Resource-starved server recovery verified."
