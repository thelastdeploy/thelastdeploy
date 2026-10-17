#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates System from Internals Capstone
# Lab: lnx-investigate-system-from-internals
# ==============================================================================

# Step 1: Ensure internals-challenge directory exists
student_exec \
  --step-name "Ensure internals-challenge directory exists" \
  --cmd "mkdir -p ~/internals-challenge" \
  --expect-exit-code 0

# Step 2: Inspect kernel version and file locks
student_exec \
  --step-name "Inspect kernel info" \
  --cmd "cat /proc/version" \
  --expect-exit-code 0

# Step 3: Write investigation proof marker
student_exec \
  --step-name "Write investigation proof marker" \
  --cmd "echo 'SYSTEM_BEHAVIOR_INVESTIGATED_FROM_INTERNALS: ROOT_CAUSE_PROVED' > ~/internals-challenge/investigation.log" \
  --expect-exit-code 0

# Step 4: Verify content of investigation.log
student_exec \
  --step-name "Verify investigation.log content" \
  --cmd "cat ~/internals-challenge/investigation.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SYSTEM_BEHAVIOR_INVESTIGATED_FROM_INTERNALS: ROOT_CAUSE_PROVED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: System behavior investigation from Linux internals capstone verified."
