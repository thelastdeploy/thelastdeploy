#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates initramfs Image Contents
# Lab: lnx-investigate-initramfs
# ==============================================================================

# Step 1: Ensure kernel-test directory exists
student_exec \
  --step-name "Ensure kernel-test directory exists" \
  --cmd "mkdir -p ~/kernel-test" \
  --expect-exit-code 0

# Step 2: Write initramfs inspected summary
student_exec \
  --step-name "Write initramfs inspection summary" \
  --cmd "echo 'INITRAMFS_INSPECTED' > ~/kernel-test/initramfs_summary.txt" \
  --expect-exit-code 0

# Step 3: Verify content of initramfs_summary.txt
student_exec \
  --step-name "Verify initramfs_summary.txt content" \
  --cmd "cat ~/kernel-test/initramfs_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "INITRAMFS_INSPECTED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: initramfs image investigation verified."
