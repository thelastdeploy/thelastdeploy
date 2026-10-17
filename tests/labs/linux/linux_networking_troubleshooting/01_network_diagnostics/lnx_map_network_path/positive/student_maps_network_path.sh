#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Maps Network Path
# Lab: lnx-map-network-path
# ==============================================================================

# Step 1: Ensure net-test directory exists
student_exec \
  --step-name "Ensure net-test directory exists" \
  --cmd "mkdir -p ~/net-test" \
  --expect-exit-code 0

# Step 2: Inspect traceroute simulation output
student_exec \
  --step-name "Inspect simulated path log" \
  --cmd "cat ~/net-test/traceroute_sim/path.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "10.20.30.40"

# Step 3: Write target hop IP address
student_exec \
  --step-name "Write target hop IP" \
  --cmd "echo '10.20.30.40' > ~/net-test/target_hop.txt" \
  --expect-exit-code 0

# Step 4: Verify content of target_hop.txt
student_exec \
  --step-name "Verify target_hop.txt content" \
  --cmd "cat ~/net-test/target_hop.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "10.20.30.40"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SUCCESS: Network path mapped successfully."
