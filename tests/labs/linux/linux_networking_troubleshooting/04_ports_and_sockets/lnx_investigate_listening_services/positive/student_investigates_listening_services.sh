#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Listening Services
# Lab: lnx-investigate-listening-services
# ==============================================================================

# Step 1: Ensure net-test directory exists
student_exec \
  --step-name "Ensure net-test directory exists" \
  --cmd "mkdir -p ~/net-test" \
  --expect-exit-code 0

# Step 2: Inspect simulated sockets output
student_exec \
  --step-name "Inspect sockets output" \
  --cmd "cat ~/net-test/sockets/ss_output.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "4251"

# Step 3: Write process PID
student_exec \
  --step-name "Write listening PID" \
  --cmd "echo '4251' > ~/net-test/port_8080_pid.txt" \
  --expect-exit-code 0

# Step 4: Verify content of port_8080_pid.txt
student_exec \
  --step-name "Verify port_8080_pid.txt content" \
  --cmd "cat ~/net-test/port_8080_pid.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "4251"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SUCCESS: Listening socket process PID identified correctly."
