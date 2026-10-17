#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Hidden System and File Activity
# Lab: lnx-investigate-hidden-system-activity
# ==============================================================================

# Step 1: Ensure trace-test directory exists
student_exec \
  --step-name "Ensure trace-test directory exists" \
  --cmd "mkdir -p ~/trace-test" \
  --expect-exit-code 0

# Step 2: Investigate unlinked open files
student_exec \
  --step-name "Check unlinked open files in /proc" \
  --cmd "ls -l /proc/*/fd/* 2>/dev/null | grep '(deleted)' || true" \
  --expect-exit-code 0

# Step 3: Write hidden activity investigated marker
student_exec \
  --step-name "Write hidden activity marker" \
  --cmd "echo 'HIDDEN_ACTIVITY_INVESTIGATED' > ~/trace-test/hidden_activity.txt" \
  --expect-exit-code 0

# Step 4: Verify content of hidden_activity.txt
student_exec \
  --step-name "Verify hidden_activity.txt content" \
  --cmd "cat ~/trace-test/hidden_activity.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "HIDDEN_ACTIVITY_INVESTIGATED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Hidden system activity investigation verified."
