#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Completes Linux Mastery Grand Capstone
# Lab: lnx-complete-linux-mastery
# ==============================================================================

# Step 1: Ensure linux-mastery directory exists
student_exec \
  --step-name "Ensure linux-mastery directory exists" \
  --cmd "mkdir -p ~/linux-mastery" \
  --expect-exit-code 0

# Step 2: Comprehensive system health check
student_exec \
  --step-name "Comprehensive system health check" \
  --cmd "uptime && df -h && free -m && ip addr show" \
  --expect-exit-code 0

# Step 3: Write grand mastery track completion marker
student_exec \
  --step-name "Write grand mastery track completion marker" \
  --cmd "echo 'GRAND_LINUX_MASTERY_TRACK_COMPLETED_SUCCESSFULLY' > ~/linux-mastery/grand_mastery_completion.log" \
  --expect-exit-code 0

# Step 4: Verify grand_mastery_completion.log content
student_exec \
  --step-name "Verify grand_mastery_completion.log content" \
  --cmd "cat ~/linux-mastery/grand_mastery_completion.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "GRAND_LINUX_MASTERY_TRACK_COMPLETED_SUCCESSFULLY"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Complete Linux Mastery Grand Capstone verified successfully."
