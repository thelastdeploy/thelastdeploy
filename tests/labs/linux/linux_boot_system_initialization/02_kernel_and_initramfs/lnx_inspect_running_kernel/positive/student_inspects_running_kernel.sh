#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Running Kernel and Parameters
# Lab: lnx-inspect-running-kernel
# ==============================================================================

# Step 1: Ensure kernel-test directory exists
student_exec \
  --step-name "Ensure kernel-test directory exists" \
  --cmd "mkdir -p ~/kernel-test" \
  --expect-exit-code 0

# Step 2: Write kernel cmdline inspected summary
student_exec \
  --step-name "Write cmdline inspection summary" \
  --cmd "echo 'KERNEL_CMDLINE_INSPECTED' > ~/kernel-test/cmdline_info.txt" \
  --expect-exit-code 0

# Step 3: Verify content of cmdline_info.txt
student_exec \
  --step-name "Verify cmdline_info.txt content" \
  --cmd "cat ~/kernel-test/cmdline_info.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "KERNEL_CMDLINE_INSPECTED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Running kernel inspection verified."
