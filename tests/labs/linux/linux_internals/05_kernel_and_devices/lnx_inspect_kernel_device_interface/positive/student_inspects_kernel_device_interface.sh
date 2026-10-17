#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Kernel and Device Interfaces
# Lab: lnx-inspect-kernel-device-interface
# ==============================================================================

# Step 1: Ensure sysfs-test directory exists
student_exec \
  --step-name "Ensure sysfs-test directory exists" \
  --cmd "mkdir -p ~/sysfs-test" \
  --expect-exit-code 0

# Step 2: Inspect sysfs device model
student_exec \
  --step-name "Inspect block devices via sysfs" \
  --cmd "ls -la /sys/block/" \
  --expect-exit-code 0

# Step 3: Write kernel device interfaces marker
student_exec \
  --step-name "Write interfaces marker" \
  --cmd "echo 'KERNEL_DEVICE_INTERFACES_INSPECTED' > ~/sysfs-test/interfaces.txt" \
  --expect-exit-code 0

# Step 4: Verify content of interfaces.txt
student_exec \
  --step-name "Verify interfaces.txt content" \
  --cmd "cat ~/sysfs-test/interfaces.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "KERNEL_DEVICE_INTERFACES_INSPECTED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Kernel device interfaces inspection verified."
