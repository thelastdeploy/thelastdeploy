#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure X-Frame-Options
# Module: nginx-security-and-performance
# Section: 02-security-headers
# Lab ID: nginx-x-frame-options
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-x-frame-options"

# Step 1: Student adds X-Frame-Options header to default site configuration
student_exec "sed -i '/server_name _;/a \\\tadd_header X-Frame-Options \"DENY\" always;' /etc/nginx/sites-available/default" \
    --desc "Student adds X-Frame-Options DENY header" \
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
    --expect-stdout "PASS: X-Frame-Options header configured successfully."
