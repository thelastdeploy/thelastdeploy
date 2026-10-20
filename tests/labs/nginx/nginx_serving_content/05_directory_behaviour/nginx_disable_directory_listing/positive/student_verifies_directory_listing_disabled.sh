#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Disable Directory Listing
# Module: nginx-serving-content
# Section: 05-directory-behaviour
# Lab ID: nginx-disable-directory-listing
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-disable-directory-listing"

# Step 1: Ensure Nginx is running
student_exec "systemctl start nginx || nginx" \
    --desc "Student ensures nginx service is active" \
    --expect-exit 0

# Step 2: Student tests accessing /secret/ and verifies 403 Forbidden
student_exec "curl -i -s http://localhost/secret/" \
    --desc "Student verifies accessing /secret/ yields 403 Forbidden" \
    --expect-exit 0 \
    --expect-stdout "403 Forbidden"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Directory listing for /secret/ is disabled."
