#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Enable HSTS
# Module: nginx-security-and-performance
# Section: 02-security-headers
# Lab ID: nginx-enable-hsts
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-enable-hsts"

# Step 1: Student adds HSTS security header to default site configuration
student_exec "sed -i '/server_name _;/a \\\tadd_header Strict-Transport-Security \"max-age=31536000; includeSubDomains\" always;' /etc/nginx/sites-available/default" \
    --desc "Student adds Strict-Transport-Security header" \
    --expect-exit 0

# Step 2: Student validates nginx configuration syntax
student_exec "nginx -t" \
    --desc "Student verifies nginx configuration syntax" \
    --expect-exit 0 \
    --expect-stderr "syntax is ok"

# Step 3: Student reloads nginx
student_exec "systemctl restart nginx" \
    --desc "Student reloads nginx service" \
    --expect-exit 0

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: HSTS security header configured successfully."
