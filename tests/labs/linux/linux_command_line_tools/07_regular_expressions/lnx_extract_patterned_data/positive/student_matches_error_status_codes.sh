#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Extract HTTP error codes using regex patterns
# Module: linux-command-line-tools
# Section: 07-regular-expressions
# Lab ID: lnx-extract-patterned-data
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-extract-patterned-data"

# Step 1: Student views the web log file
student_exec "cat ~/regex-test/web.log" \
    --desc "Student inspects raw web log in ~/regex-test/web.log" \
    --expect-exit 0 \
    --expect-stdout "404 Not Found"

# Step 2: Student filters log for status code 404 or 500 using alternation
student_exec "grep -E ' (404|500) ' ~/regex-test/web.log" \
    --desc "Student filters lines matching status 404 or 500 using grep -E" \
    --expect-exit 0 \
    --expect-stdout "500 Error"

# Step 3: Student counts the matching lines using grep -c
student_exec "grep -c -E ' (404|500) ' ~/regex-test/web.log" \
    --desc "Student counts matching lines with grep -c" \
    --expect-exit 0 \
    --expect-stdout "3"

# Step 4: Student redirects count into error_status_count.txt
student_exec "grep -c -E ' (404|500) ' ~/regex-test/web.log > ~/regex-test/error_status_count.txt" \
    --desc "Student saves total count to ~/regex-test/error_status_count.txt" \
    --expect-exit 0

# Step 5: Student confirms the content of error_status_count.txt
student_exec "cat ~/regex-test/error_status_count.txt" \
    --desc "Student verifies the contents of ~/regex-test/error_status_count.txt" \
    --expect-exit 0 \
    --expect-stdout "3"

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: HTTP error status count verified."
