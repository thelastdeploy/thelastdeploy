#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix a 502 Bad Gateway Error
# Module: nginx-troubleshooting
# Section: 03-common-http-errors
# Lab ID: nginx-fix-502
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-fix-502"

# Step 1: Student updates proxy_pass port to match backend port 8080
student_exec "sudo sed -i 's|http://127.0.0.1:9090|http://127.0.0.1:8080|g' /etc/nginx/sites-available/default" \
    --desc "Student updates upstream proxy destination to active backend port 8080" \
    --expect-exit 0

# Step 2: Student tests configuration syntax and reloads Nginx
student_exec "sudo nginx -t && sudo systemctl restart nginx" \
    --desc "Student tests syntax and reloads Nginx service" \
    --expect-exit 0

# Step 3: Student verifies response from /api endpoint
student_exec "curl -s http://localhost/api" \
    --desc "Student verifies API OK response from proxied backend" \
    --expect-exit 0 \
    --expect-stdout "API OK"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: 502 Bad Gateway error resolved successfully."
