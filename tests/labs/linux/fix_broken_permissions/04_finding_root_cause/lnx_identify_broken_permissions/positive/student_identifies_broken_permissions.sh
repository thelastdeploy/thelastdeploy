#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Identifies Broken Permissions
# Lab: lnx-identify-broken-permissions
# ==============================================================================

# Step 1: Inspect application log permissions
student_exec \
  --step-name "Inspect application log permissions" \
  --cmd "ls -l /var/log/app-server.log" \
  --expect-exit-code 0

# Step 2: Record root cause confirmation marker
student_exec \
  --step-name "Record root cause confirmation marker" \
  --cmd "touch /tmp/found_root_cause" \
  --expect-exit-code 0

# Step 3: Verify marker file exists
student_exec \
  --step-name "Verify marker file exists" \
  --cmd "test -f /tmp/found_root_cause" \
  --expect-exit-code 0

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Root cause identified successfully."
