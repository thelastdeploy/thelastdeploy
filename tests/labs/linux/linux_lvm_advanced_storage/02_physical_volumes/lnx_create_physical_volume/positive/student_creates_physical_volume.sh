#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Creates and Initializes Physical Volume
# Lab: lnx-create-physical-volume
# ==============================================================================

# Step 1: Ensure pv-test directory exists
student_exec \
  --step-name "Ensure pv-test directory exists" \
  --cmd "mkdir -p ~/pv-test" \
  --expect-exit-code 0

# Step 2: Write summary line to pv_info.txt
student_exec \
  --step-name "Write pvcreate summary" \
  --cmd "echo 'PV_CREATE_COMMAND_VERIFIED' > ~/pv-test/pv_info.txt" \
  --expect-exit-code 0

# Step 3: Verify content of pv_info.txt
student_exec \
  --step-name "Verify pv_info.txt content" \
  --cmd "cat ~/pv-test/pv_info.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PV_CREATE_COMMAND_VERIFIED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Physical volume creation command verified."
