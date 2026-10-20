#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix a 404 Not Found Error
# Module: nginx-troubleshooting
# Section: 03-common-http-errors
# Lab ID: nginx-fix-404
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-fix-404"

# Step 1: Student corrects root directive typo in default site configuration
student_exec "sudo sed -i 's|root /var/www/htm;|root /var/www/html;|g' /etc/nginx/sites-available/default" \
    --desc "Student corrects document root path in configuration" \
    --expect-exit 0

# Step 2: Student tests configuration syntax and reloads Nginx
student_exec "sudo nginx -t && sudo systemctl restart nginx" \
    --desc "Student tests syntax and reloads Nginx service" \
    --expect-exit 0

# Step 3: Student verifies HTTP response code
student_exec "curl -s -o /dev/null -w '%{http_code}' http://localhost/" \
    --desc "Student verifies HTTP 200 response" \
    --expect-exit 0 \
    --expect-stdout "200"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: 404 Not Found error resolved successfully."
