#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure Custom Index
# Module: nginx-serving-content
# Section: 03-index-files
# Lab ID: nginx-custom-index
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-custom-index"

# Step 1: Student checks pre-seeded custom.html file exists
student_exec "cat /var/www/html/custom.html" \
    --desc "Student inspects pre-seeded custom.html" \
    --expect-exit 0 \
    --expect-stdout "Custom welcome page"

# Step 2: Student updates index directive to prioritize custom.html
student_exec "sed -i 's/index index.html/index custom.html index.html/' /etc/nginx/sites-available/default" \
    --desc "Student updates index directive in default site" \
    --expect-exit 0

# Step 3: Student tests configuration syntax
student_exec "nginx -t" \
    --desc "Student tests nginx configuration syntax" \
    --expect-exit 0 \
    --expect-stderr "syntax is ok"

# Step 4: Student reloads nginx
student_exec "systemctl restart nginx" \
    --desc "Student reloads nginx service" \
    --expect-exit 0

# Step 5: Student confirms server root returns custom welcome page
student_exec "curl -s http://localhost/" \
    --desc "Student fetches homepage from local nginx server" \
    --expect-exit 0 \
    --expect-stdout "Custom welcome page"

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Custom index prioritised and loaded successfully."
