#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Combined find and grep operations
# Module: linux-fundamentals
# Section: 07-file-searching
# Lab ID: lnx-combined-search
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-combined-search"

# Step 1: Student inspects the logs folder
student_exec "ls -la ~/search-test/logs" \
    --desc "Student inspects log files in ~/search-test/logs" \
    --expect-exit 0 \
    --expect-stdout "error-log-1.txt"

# Step 2: Student searches for files containing the FATAL keyword
student_exec "grep -l 'FATAL' ~/search-test/logs/*" \
    --desc "Student uses grep -l to identify which log contains FATAL" \
    --expect-exit 0 \
    --expect-stdout "error-log-1.txt"

# Step 3: Student confirms the matching line inside the file
student_exec "grep 'FATAL' ~/search-test/logs/error-log-1.txt" \
    --desc "Student verifies the fatal error line inside the file" \
    --expect-exit 0 \
    --expect-stdout "FATAL: system exploded"

# Step 4: Student writes the log file path into fatal_log.txt
student_exec "grep -l 'FATAL' ~/search-test/logs/* > ~/search-test/fatal_log.txt" \
    --desc "Student saves the fatal log path into ~/search-test/fatal_log.txt" \
    --expect-exit 0

# Step 5: Intermediate verification by reading back fatal_log.txt
student_exec "cat ~/search-test/fatal_log.txt" \
    --desc "Student verifies contents of fatal_log.txt" \
    --expect-exit 0 \
    --expect-stdout "error-log-1.txt"

# Step 6: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Fatal log file found successfully"
