#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Search logs using less
# Module: linux-fundamentals
# Section: 06-viewing-files
# Lab ID: lnx-less-logfile
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-less-logfile"

# Step 1: Student inspects the view-test directory
student_exec "ls -la ~/view-test" \
    --desc "Student inspects contents of ~/view-test" \
    --expect-exit 0 \
    --expect-stdout "system.log"

# Step 2: Student searches for the target error line
student_exec "grep 'ERR_CONN_TIMEOUT' ~/view-test/system.log" \
    --desc "Student locates ERR_CONN_TIMEOUT line in system.log" \
    --expect-exit 0 \
    --expect-stdout "2026-06-10T12:00:00Z"

# Step 3: Student extracts the timestamp from the error line
student_exec "grep 'ERR_CONN_TIMEOUT' ~/view-test/system.log | cut -d' ' -f1" \
    --desc "Student isolates the ISO timestamp column" \
    --expect-exit 0 \
    --expect-stdout "2026-06-10T12:00:00Z"

# Step 4: Student saves the timestamp into ~/view-test/error_time.txt
student_exec "grep 'ERR_CONN_TIMEOUT' ~/view-test/system.log | cut -d' ' -f1 > ~/view-test/error_time.txt" \
    --desc "Student saves timestamp into ~/view-test/error_time.txt" \
    --expect-exit 0

# Step 5: Intermediate verification by reading back error_time.txt
student_exec "cat ~/view-test/error_time.txt" \
    --desc "Student verifies the contents of error_time.txt" \
    --expect-exit 0 \
    --expect-stdout "2026-06-10T12:00:00Z"

# Step 6: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Log searched successfully"
