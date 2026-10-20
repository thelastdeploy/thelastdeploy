#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Limit Request Rate
# Module: nginx-security-and-performance
# Section: 03-rate-limiting
# Lab ID: nginx-limit-requests
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-limit-requests"

# Step 1: Student defines rate limit zone in /etc/nginx/nginx.conf
student_exec "sed -i '/http {/a \\\tlimit_req_zone \$binary_remote_addr zone=mylimit:10m rate=5r/s;' /etc/nginx/nginx.conf" \
    --desc "Student defines limit_req_zone in nginx.conf" \
    --expect-exit 0

# Step 2: Student applies limit_req in location /api/ in default site configuration
student_exec "sed -i '/location \\/api\\/ {/a \\\t\\tlimit_req zone=mylimit burst=10 nodelay;' /etc/nginx/sites-available/default" \
    --desc "Student applies rate limit directive inside /api/ location" \
    --expect-exit 0

# Step 3: Student validates nginx configuration syntax
student_exec "nginx -t" \
    --desc "Student verifies nginx configuration syntax" \
    --expect-exit 0 \
    --expect-stderr "syntax is ok"

# Step 4: Student reloads nginx
student_exec "systemctl restart nginx" \
    --desc "Student reloads nginx service" \
    --expect-exit 0

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Rate limiting configured successfully."
