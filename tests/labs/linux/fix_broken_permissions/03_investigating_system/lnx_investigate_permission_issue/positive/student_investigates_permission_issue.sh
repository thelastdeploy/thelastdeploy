#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Permission Issue
# Lab: lnx-investigate-permission-issue
# ==============================================================================

# Step 1: Inspect application log permissions
student_exec \
  --step-name "Inspect application log permissions" \
  --cmd "ls -l /var/log/app-server.log" \
  --expect-exit-code 0

# Step 2: Record log inspection marker
student_exec \
  --step-name "Record log inspection marker" \
  --cmd "touch /tmp/checked_logs" \
  --expect-exit-code 0

# Step 3: Verify marker file exists
student_exec \
  --step-name "Verify marker file exists" \
  --cmd "test -f /tmp/checked_logs" \
  --expect-exit-code 0

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Investigated broken log permissions successfully."
