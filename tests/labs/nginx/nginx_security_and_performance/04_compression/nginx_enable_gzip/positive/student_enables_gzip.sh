#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Enable Gzip Compression
# Module: nginx-security-and-performance
# Section: 04-compression
# Lab ID: nginx-enable-gzip
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-enable-gzip"

# Step 1: Student enables gzip and specifies gzip_types in /etc/nginx/nginx.conf
student_exec "sed -i '/gzip on;/a \\\tgzip_types text/css application/json;' /etc/nginx/nginx.conf" \
    --desc "Student adds gzip_types directive to nginx.conf" \
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
    --expect-stdout "PASS: Gzip compression configured successfully."
