#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Forward Host Header
# Module: nginx-reverse-proxy
# Section: 03-forwarding-headers
# Lab ID: nginx-forward-host-header
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-forward-host-header"

# Step 1: Student adds proxy_set_header Host $host into location /node
student_exec "sed -i '/location \\/node {/a \\\t\\tproxy_set_header Host \\\$host;' /etc/nginx/sites-available/default" \
    --desc "Student adds Host header forwarding to /node location" \
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
    --expect-stdout "PASS: Host header forwarding configured successfully."
