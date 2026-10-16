#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Build a multi-stage command pipeline
# Module: linux-command-line-tools
# Section: 05-pipelines
# Lab ID: lnx-build-command-pipeline
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-build-command-pipeline"

# Step 1: Student inspects the access log file
student_exec "cat ~/pipe-test/access.log" \
    --desc "Student inspects raw access logs in ~/pipe-test/access.log" \
    --expect-exit 0 \
    --expect-stdout "POST /login"

# Step 2: Student filters the log for POST requests
student_exec "grep 'POST' ~/pipe-test/access.log" \
    --desc "Student filters access log for lines containing POST" \
    --expect-exit 0 \
    --expect-stdout "10.0.0.99"

# Step 3: Student extracts the client IP address (column 1)
student_exec "grep 'POST' ~/pipe-test/access.log | awk '{print \$1}'" \
    --desc "Student isolates the client IP address column using awk" \
    --expect-exit 0 \
    --expect-stdout "10.0.0.99"

# Step 4: Student aggregates and counts occurrences per IP
student_exec "grep 'POST' ~/pipe-test/access.log | awk '{print \$1}' | sort | uniq -c | sort -nr" \
    --desc "Student counts and ranks POST requests per IP in descending order" \
    --expect-exit 0 \
    --expect-stdout "3 10.0.0.99"

# Step 5: Student isolates the top IP address
student_exec "grep 'POST' ~/pipe-test/access.log | awk '{print \$1}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print \$2}'" \
    --desc "Student isolates the top IP address" \
    --expect-exit 0 \
    --expect-stdout "10.0.0.99"

# Step 6: Student saves the top IP into top_poster.txt
student_exec "grep 'POST' ~/pipe-test/access.log | awk '{print \$1}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print \$2}' > ~/pipe-test/top_poster.txt" \
    --desc "Student saves top IP address into ~/pipe-test/top_poster.txt" \
    --expect-exit 0

# Step 7: Student verifies the saved file content
student_exec "cat ~/pipe-test/top_poster.txt" \
    --desc "Student verifies the contents of ~/pipe-test/top_poster.txt" \
    --expect-exit 0 \
    --expect-stdout "10.0.0.99"

# Step 8: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Multi-stage pipeline result verified successfully."
