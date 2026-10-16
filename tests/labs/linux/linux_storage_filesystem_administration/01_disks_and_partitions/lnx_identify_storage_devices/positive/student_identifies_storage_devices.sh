#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Identifies Storage Devices and Block Topology
# Lab: lnx-identify-storage-devices
# ==============================================================================

# Step 1: Ensure storage-test directory exists
student_exec \
  --step-name "Ensure storage-test directory exists" \
  --cmd "mkdir -p ~/storage-test" \
  --expect-exit-code 0

# Step 2: List block devices or copy simulated device dump to block_devices.txt
student_exec \
  --step-name "Generate block devices inventory" \
  --cmd "if [ -f ~/storage-test/device_dump.txt ]; then
  cp ~/storage-test/device_dump.txt ~/storage-test/block_devices.txt
else
  lsblk > ~/storage-test/block_devices.txt
fi" \
  --expect-exit-code 0

# Step 3: Verify block_devices.txt content
student_exec \
  --step-name "Verify block_devices.txt content" \
  --cmd "cat ~/storage-test/block_devices.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "sda"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Block storage device identification verified."
