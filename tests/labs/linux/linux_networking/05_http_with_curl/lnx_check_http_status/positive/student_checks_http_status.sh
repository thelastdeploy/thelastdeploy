#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Retrieve HTTP status code
# Module: linux-networking
# Section: 05-http-with-curl
# Lab ID: lnx-check-http-status
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-check-http-status"

# Step 1: Student inspects HTTP headers
student_exec "curl -I http://127.0.0.1:9090" \
    --desc "Student queries HTTP response headers" \
    --expect-exit 0 \
    --expect-stdout "200"

# Step 2: Student extracts numeric status code and writes to http_status.txt
student_exec "mkdir -p ~/network-test && curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:9090 > ~/network-test/http_status.txt" \
    --desc "Student extracts and saves HTTP status code" \
    --expect-exit 0

# Step 3: Student verifies recorded status code
student_exec "cat ~/network-test/http_status.txt" \
    --desc "Student verifies recorded HTTP status code" \
    --expect-exit 0 \
    --expect-stdout "200"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: HTTP status code verified successfully."
