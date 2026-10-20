#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Identify Startup Error
# Module: nginx-troubleshooting
# Section: 02-reading-error-logs
# Lab ID: nginx-identify-startup-error
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-identify-startup-error"

# Step 1: Student extracts port from bind failure in error.log
student_exec "grep -o '0\.0\.0\.0:[0-9]\+' /var/log/nginx/error.log | tail -n 1 | cut -d: -f2 > /tmp/failed_port.txt" \
    --desc "Student extracts failed port number from Nginx error log" \
    --expect-exit 0

# Step 2: Student verifies file content contains target port
student_exec "cat /tmp/failed_port.txt" \
    --desc "Student verifies extracted port number" \
    --expect-exit 0 \
    --expect-stdout "9999"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Bind failure port identified successfully."
