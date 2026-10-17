#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Linux From Kernel Up
# Lab: lnx-investigate-linux-from-kernel-up
# ==============================================================================

# Step 1: Ensure mastery-internals directory exists
student_exec \
  --step-name "Ensure mastery-internals directory exists" \
  --cmd "mkdir -p ~/mastery-internals" \
  --expect-exit-code 0

# Step 2: Audit kernel procfs and sysfs structures
student_exec \
  --step-name "Audit kernel procfs and sysfs structures" \
  --cmd "ls -d /proc/[0-9]* 2>/dev/null | head -n 5 && ls -d /sys/kernel/* 2>/dev/null | head -n 5" \
  --expect-exit-code 0

# Step 3: Write internals mastery marker
student_exec \
  --step-name "Write internals mastery marker" \
  --cmd "echo 'KERNEL_AND_SYSTEM_INTERNALS_MASTERED' > ~/mastery-internals/internals_mastery.log" \
  --expect-exit-code 0

# Step 4: Verify internals_mastery.log content
student_exec \
  --step-name "Verify internals_mastery.log content" \
  --cmd "cat ~/mastery-internals/internals_mastery.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "KERNEL_AND_SYSTEM_INTERNALS_MASTERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Investigate Linux From Kernel Up verified successfully."
