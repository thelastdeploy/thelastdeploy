#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Verifies Application Recovery
# Lab: lnx-verify-application-recovery
# ==============================================================================

# Step 1: Inspect application log permissions
student_exec \
  --step-name "Inspect application log permissions" \
  --cmd "ls -l /var/log/app-server.log" \
  --expect-exit-code 0

# Step 2: Record application recovery confirmation marker
student_exec \
  --step-name "Record application recovery confirmation marker" \
  --cmd "touch /tmp/recovery_verified" \
  --expect-exit-code 0

# Step 3: Verify marker file exists
student_exec \
  --step-name "Verify marker file exists" \
  --cmd "test -f /tmp/recovery_verified" \
  --expect-exit-code 0

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Application recovery verified successfully!"
