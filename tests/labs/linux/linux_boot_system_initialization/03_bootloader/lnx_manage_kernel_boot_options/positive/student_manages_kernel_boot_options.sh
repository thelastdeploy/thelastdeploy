#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Manages Kernel Boot Parameters
# Lab: lnx-manage-kernel-boot-options
# ==============================================================================

# Step 1: Ensure grub-test directory exists
student_exec \
  --step-name "Ensure grub-test directory exists" \
  --cmd "mkdir -p ~/grub-test" \
  --expect-exit-code 0

# Step 2: Write custom kernel flags to kernel_flags.txt
student_exec \
  --step-name "Write custom kernel flags" \
  --cmd "echo 'GRUB_CMDLINE_LINUX=\"quiet splash systemd.unit=multi-user.target\"' > ~/grub-test/kernel_flags.txt" \
  --expect-exit-code 0

# Step 3: Verify content of kernel_flags.txt
student_exec \
  --step-name "Verify kernel_flags.txt content" \
  --cmd "cat ~/grub-test/kernel_flags.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "systemd.unit=multi-user.target"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Kernel boot parameter management verified."
