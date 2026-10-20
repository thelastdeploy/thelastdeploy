#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure Custom 404 Page
# Module: nginx-serving-content
# Section: 04-custom-error-pages
# Lab ID: nginx-custom-404
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-custom-404"

# Step 1: Student creates /var/www/html/404.html
student_exec "echo 'Custom 404 - File Not Found' > /var/www/html/404.html" \
    --desc "Student creates custom 404 HTML file" \
    --expect-exit 0

# Step 2: Student adds error_page 404 directive to default site
student_exec "sed -i '/server_name _;/a \    error_page 404 /404.html;' /etc/nginx/sites-available/default" \
    --desc "Student adds error_page 404 directive in default site" \
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

# Step 5: Student tests 404 response
student_exec "curl -i -s http://localhost/doesnotexist" \
    --desc "Student verifies custom 404 response" \
    --expect-exit 0 \
    --expect-stdout "Custom 404 - File Not Found"

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Custom 404 error page successfully configured."
