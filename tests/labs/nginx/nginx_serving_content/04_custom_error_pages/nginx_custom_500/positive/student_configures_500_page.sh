#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure Custom 500 Page
# Module: nginx-serving-content
# Section: 04-custom-error-pages
# Lab ID: nginx-custom-500
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-custom-500"

# Step 1: Student creates /var/www/html/50x.html
student_exec "echo 'Custom 50x - Server Error' > /var/www/html/50x.html" \
    --desc "Student creates custom 50x HTML file" \
    --expect-exit 0

# Step 2: Student adds error_page 500 502 503 504 directive to default site
student_exec "sed -i '/server_name _;/a \    error_page 500 502 503 504 /50x.html;' /etc/nginx/sites-available/default" \
    --desc "Student configures error_page for 500-series status codes" \
    --expect-exit 0

# Step 3: Student validates configuration syntax
student_exec "nginx -t" \
    --desc "Student verifies nginx configuration syntax" \
    --expect-exit 0 \
    --expect-stderr "syntax is ok"

# Step 4: Student reloads nginx
student_exec "systemctl restart nginx" \
    --desc "Student reloads nginx service" \
    --expect-exit 0

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Custom 50x error pages successfully configured."
