#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Find Client Request
# Module: nginx-troubleshooting
# Section: 01-reading-access-logs
# Lab ID: nginx-find-client-request
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-find-client-request"

# Step 1: Student greps for SecretAgent in access.log and extracts the client IP address
student_exec "grep 'SecretAgent' /var/log/nginx/access.log | awk '{print \$1}' > /tmp/client_ip.txt" \
    --desc "Student extracts client IP from access log by User-Agent" \
    --expect-exit 0

# Step 2: Student verifies file content contains target IP
student_exec "cat /tmp/client_ip.txt" \
    --desc "Student verifies extracted IP address" \
    --expect-exit 0 \
    --expect-stdout "192.168.12.34"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Client IP extracted and written successfully."
