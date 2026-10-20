#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix a 500 Internal Server Error
# Module: nginx-troubleshooting
# Section: 03-common-http-errors
# Lab ID: nginx-fix-500
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-fix-500"

# Step 1: Student removes circular rewrite directives and serves static index
student_exec "sudo sed -i '/rewrite \^/d' /etc/nginx/sites-available/default && sudo sed -i '/location \/loop {/a \        try_files /index.html =404;' /etc/nginx/sites-available/default" \
    --desc "Student removes circular rewrite rules and configures static file fallback" \
    --expect-exit 0

# Step 2: Student tests configuration syntax and reloads Nginx
student_exec "sudo nginx -t && sudo systemctl restart nginx" \
    --desc "Student tests syntax and reloads Nginx service" \
    --expect-exit 0

# Step 3: Student verifies /loop does not return HTTP 500
student_exec "curl -s -o /dev/null -w '%{http_code}' http://localhost/loop" \
    --desc "Student verifies HTTP 200 response from /loop" \
    --expect-exit 0 \
    --expect-stdout "200"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: 500 Internal Server Error (rewrite loop) resolved successfully."
