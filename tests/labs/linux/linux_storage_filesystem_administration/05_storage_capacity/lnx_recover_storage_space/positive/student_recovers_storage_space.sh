#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Storage Space
# Lab: lnx-recover-storage-space
# ==============================================================================

# Step 1: Verify cleanup_target/logs directory exists
student_exec \
  --step-name "Verify logs directory exists" \
  --cmd "ls -la ~/storage-test/cleanup_target/logs" \
  --expect-exit-code 0

# Step 2: Remove the stale backup log file old_app_log.bak while preserving app.log
student_exec \
  --step-name "Delete stale backup log" \
  --cmd "rm ~/storage-test/cleanup_target/logs/old_app_log.bak" \
  --expect-exit-code 0

# Step 3: Verify active log remains and backup log is removed
student_exec \
  --step-name "Verify log removal and retention" \
  --cmd "test -f ~/storage-test/cleanup_target/logs/app.log && ! test -f ~/storage-test/cleanup_target/logs/old_app_log.bak" \
  --expect-exit-code 0

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Stale log backup removed and storage space recovered."
