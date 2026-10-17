#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Creates Virtual Network Interfaces
# Lab: lnx-create-virtual-network-interface
# ==============================================================================

# Step 1: Ensure vnet-test directory exists
student_exec \
  --step-name "Ensure vnet-test directory exists" \
  --cmd "mkdir -p ~/vnet-test" \
  --expect-exit-code 0

# Step 2: Write virtual interface verification line
student_exec \
  --step-name "Write vif verification summary" \
  --cmd "echo 'DUMMY_INTERFACE_VERIFIED' > ~/vnet-test/vif_summary.txt" \
  --expect-exit-code 0

# Step 3: Verify content of vif_summary.txt
student_exec \
  --step-name "Verify vif_summary.txt content" \
  --cmd "cat ~/vnet-test/vif_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "DUMMY_INTERFACE_VERIFIED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Virtual network interface creation verified."
