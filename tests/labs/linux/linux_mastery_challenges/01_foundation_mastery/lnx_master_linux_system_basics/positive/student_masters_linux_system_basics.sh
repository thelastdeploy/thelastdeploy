#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Masters Linux System Basics
# Lab: lnx-master-linux-system-basics
# ==============================================================================

# Step 1: Ensure mastery-foundation directory exists
student_exec \
  --step-name "Ensure mastery-foundation directory exists" \
  --cmd "mkdir -p ~/mastery-foundation" \
  --expect-exit-code 0

# Step 2: Audit basic environment and system info
student_exec \
  --step-name "Audit basic environment and system info" \
  --cmd "env | head -n 5 && uname -r" \
  --expect-exit-code 0

# Step 3: Write basics mastery marker
student_exec \
  --step-name "Write basics mastery marker" \
  --cmd "echo 'FOUNDATION_SYSTEM_BASICS_MASTERED' > ~/mastery-foundation/basics_mastery.log" \
  --expect-exit-code 0

# Step 4: Verify basics_mastery.log content
student_exec \
  --step-name "Verify basics_mastery.log content" \
  --cmd "cat ~/mastery-foundation/basics_mastery.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "FOUNDATION_SYSTEM_BASICS_MASTERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Master Linux System Basics verified successfully."
