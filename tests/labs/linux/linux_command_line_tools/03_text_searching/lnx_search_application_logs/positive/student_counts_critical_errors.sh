#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Search application logs for critical errors
# Module: linux-command-line-tools
# Section: 03-text-searching
# Lab ID: lnx-search-application-logs
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-search-application-logs"

# Step 1: Student inspects the application log file
student_exec "cat ~/grep-test/app.log" \
    --desc "Student inspects the log contents in app.log" \
    --expect-exit 0 \
    --expect-stdout "CRITICAL Database connection failed"

# Step 2: Student tests matching lines containing CRITICAL
student_exec "grep 'CRITICAL' ~/grep-test/app.log" \
    --desc "Student executes grep to view critical error lines" \
    --expect-exit 0 \
    --expect-stdout "Out of memory in worker 2"

# Step 3: Student calculates the matching count using grep -c
student_exec "grep -c 'CRITICAL' ~/grep-test/app.log" \
    --desc "Student calculates the line count using grep -c" \
    --expect-exit 0 \
    --expect-stdout "2"

# Step 4: Student redirects the count into critical_count.txt
student_exec "grep -c 'CRITICAL' ~/grep-test/app.log > ~/grep-test/critical_count.txt" \
    --desc "Student redirects the critical count into critical_count.txt" \
    --expect-exit 0

# Step 5: Student confirms the written file content
student_exec "cat ~/grep-test/critical_count.txt" \
    --desc "Student checks ~/grep-test/critical_count.txt content" \
    --expect-exit 0 \
    --expect-stdout "2"

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Application log search count verified."
