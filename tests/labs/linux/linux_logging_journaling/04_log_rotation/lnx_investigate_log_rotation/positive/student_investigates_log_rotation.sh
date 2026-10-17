#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Log Rotation Archives
# Lab: lnx-investigate-log-rotation
# ==============================================================================

# Step 1: Ensure archives directory exists with sample app.log.1.gz if missing
student_exec \
  --step-name "Ensure sample app.log.1.gz exists" \
  --cmd "mkdir -p ~/log-test/archives && [ -f ~/log-test/archives/app.log.1.gz ] || echo '[2026-09-19 23:59:00] CRITICAL_DATABASE_FAIL: Connection reset' | gzip > ~/log-test/archives/app.log.1.gz" \
  --expect-exit-code 0

# Step 2: Search compressed archive and save critical fault line
student_exec \
  --step-name "Search compressed archive with zgrep" \
  --cmd "zgrep 'CRITICAL' ~/log-test/archives/app.log.1.gz > ~/log-test/archived_fault.txt" \
  --expect-exit-code 0

# Step 3: Verify content of archived_fault.txt
student_exec \
  --step-name "Verify archived_fault.txt content" \
  --cmd "cat ~/log-test/archived_fault.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "CRITICAL_DATABASE_FAIL"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Compressed log archive investigation verified."
