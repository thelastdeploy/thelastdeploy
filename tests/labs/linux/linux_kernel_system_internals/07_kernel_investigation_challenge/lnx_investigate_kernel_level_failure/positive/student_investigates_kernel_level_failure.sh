#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Kernel-Level Failure
# Lab: lnx-investigate-kernel-level-failure
# ==============================================================================

# Step 1: Ensure kernel-failure directory exists
student_exec \
  --step-name "Ensure kernel-failure directory exists" \
  --cmd "mkdir -p ~/kernel-failure" \
  --expect-exit-code 0

# Step 2: Inspect kernel memory and file limits
student_exec \
  --step-name "Inspect VFS file limits" \
  --cmd "cat /proc/sys/fs/file-nr" \
  --expect-exit-code 0

# Step 3: Write kernel investigation marker
student_exec \
  --step-name "Write kernel investigation marker" \
  --cmd "echo 'KERNEL_LEVEL_FAILURE_ROOT_CAUSE_DIAGNOSED' > ~/kernel-failure/kernel_investigation.log" \
  --expect-exit-code 0

# Step 4: Verify content of kernel_investigation.log
student_exec \
  --step-name "Verify kernel_investigation.log content" \
  --cmd "cat ~/kernel-failure/kernel_investigation.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "KERNEL_LEVEL_FAILURE_ROOT_CAUSE_DIAGNOSED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Investigate Kernel-Level Failure verified successfully."
