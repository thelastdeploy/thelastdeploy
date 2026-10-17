#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Kernel Modules
# Lab: lnx-investigate-kernel-modules
# ==============================================================================

# Step 1: Ensure kernel-modules directory exists
student_exec \
  --step-name "Ensure kernel-modules directory exists" \
  --cmd "mkdir -p ~/kernel-modules" \
  --expect-exit-code 0

# Step 2: Inspect loaded kernel modules
student_exec \
  --step-name "Inspect /proc/modules" \
  --cmd "head -n 10 /proc/modules" \
  --expect-exit-code 0

# Step 3: Write module analysis marker
student_exec \
  --step-name "Write module analysis marker" \
  --cmd "echo 'KERNEL_MODULES_AND_PARAMETERS_ANALYZED' > ~/kernel-modules/module_analysis.txt" \
  --expect-exit-code 0

# Step 4: Verify content of module_analysis.txt
student_exec \
  --step-name "Verify module_analysis.txt content" \
  --cmd "cat ~/kernel-modules/module_analysis.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "KERNEL_MODULES_AND_PARAMETERS_ANALYZED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Investigate Kernel Modules verified successfully."
