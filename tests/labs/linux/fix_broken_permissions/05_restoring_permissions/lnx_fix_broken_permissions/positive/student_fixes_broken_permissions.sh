#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Fixes Broken Permissions
# Lab: lnx-fix-broken-permissions
# ==============================================================================

# Step 1: Inspect application log permissions
student_exec \
  --step-name "Inspect application log permissions" \
  --cmd "ls -l /var/log/app-server.log" \
  --expect-exit-code 0

# Step 2: Restore readable permissions to log file
student_exec \
  --step-name "Restore readable permissions to log file" \
  --cmd "sudo chmod 644 /var/log/app-server.log" \
  --expect-exit-code 0

# Step 3: Verify restored permissions
student_exec \
  --step-name "Verify restored permissions" \
  --cmd "test -r /var/log/app-server.log" \
  --expect-exit-code 0

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Restored readable permissions on /var/log/app-server.log!"
