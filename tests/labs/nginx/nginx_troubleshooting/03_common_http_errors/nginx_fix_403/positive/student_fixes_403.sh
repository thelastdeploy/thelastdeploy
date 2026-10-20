#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix a 403 Forbidden Error
# Module: nginx-troubleshooting
# Section: 03-common-http-errors
# Lab ID: nginx-fix-403
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-fix-403"

# Step 1: Student updates file permissions to make index.html readable
student_exec "sudo chmod 644 /var/www/html/index.html" \
    --desc "Student restores readable permissions on index.html" \
    --expect-exit 0

# Step 2: Student tests HTTP response code
student_exec "curl -s -o /dev/null -w '%{http_code}' http://localhost/" \
    --desc "Student verifies HTTP 200 response" \
    --expect-exit 0 \
    --expect-stdout "200"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: 403 Forbidden error resolved successfully."
