#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces Device Kernel Interface
# Lab: lnx-trace-device-kernel-interface
# ==============================================================================

# Step 1: Ensure kernel-modules directory exists
student_exec \
  --step-name "Ensure kernel-modules directory exists" \
  --cmd "mkdir -p ~/kernel-modules" \
  --expect-exit-code 0

# Step 2: Inspect devices and misc
student_exec \
  --step-name "Inspect /proc/devices" \
  --cmd "cat /proc/devices" \
  --expect-exit-code 0

# Step 3: Write device interface trace marker
student_exec \
  --step-name "Write device interface marker" \
  --cmd "echo 'DEVICE_MAJOR_MINOR_INTERFACE_TRACED' > ~/kernel-modules/device_interface.log" \
  --expect-exit-code 0

# Step 4: Verify content of device_interface.log
student_exec \
  --step-name "Verify device_interface.log content" \
  --cmd "cat ~/kernel-modules/device_interface.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "DEVICE_MAJOR_MINOR_INTERFACE_TRACED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Trace Device Kernel Interface verified successfully."
