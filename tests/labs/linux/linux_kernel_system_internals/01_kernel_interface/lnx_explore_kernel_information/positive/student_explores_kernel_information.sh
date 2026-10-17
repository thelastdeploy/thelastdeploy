#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Explores Kernel Information
# Lab: lnx-explore-kernel-information
# ==============================================================================

# Step 1: Ensure kernel-interface directory exists
student_exec \
  --step-name "Ensure kernel-interface directory exists" \
  --cmd "mkdir -p ~/kernel-interface" \
  --expect-exit-code 0

# Step 2: Inspect kernel version and cmdline
student_exec \
  --step-name "Inspect kernel version" \
  --cmd "cat /proc/version" \
  --expect-exit-code 0

# Step 3: Write kernel info marker
student_exec \
  --step-name "Write kernel info marker" \
  --cmd "echo 'KERNEL_VERSION_AND_CMDLINE_INSPECTED' > ~/kernel-interface/kernel_info.txt" \
  --expect-exit-code 0

# Step 4: Verify content of kernel_info.txt
student_exec \
  --step-name "Verify kernel_info.txt content" \
  --cmd "cat ~/kernel-interface/kernel_info.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "KERNEL_VERSION_AND_CMDLINE_INSPECTED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Explore Kernel Information verified successfully."
