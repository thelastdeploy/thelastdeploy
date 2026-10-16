#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Default System Boot Target
# Lab: lnx-investigate-system-target
# ==============================================================================

# Step 1: Ensure target-test directory exists
student_exec \
  --step-name "Create target-test directory" \
  --cmd "mkdir -p ~/target-test" \
  --expect-exit-code 0

# Step 2: Query default target and write to target_info.txt
student_exec \
  --step-name "Inspect default boot target" \
  --cmd "TARGET=\$(systemctl get-default 2>/dev/null || echo 'multi-user.target')
echo \"DEFAULT_TARGET: \$TARGET\" > ~/target-test/target_info.txt" \
  --expect-exit-code 0

# Step 3: Verify target_info.txt content
student_exec \
  --step-name "Verify target_info.txt content" \
  --cmd "cat ~/target-test/target_info.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "DEFAULT_TARGET: "

# Step 4: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: System target investigation verified."
