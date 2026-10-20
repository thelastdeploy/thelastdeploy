#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure HTTP Redirect
# Module: nginx-routing
# Section: 04-redirects
# Lab ID: nginx-http-redirect
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-http-redirect"

# Step 1: Student adds location /google redirecting to https://www.google.com
student_exec "sed -i '/server_name _;/a \\\tlocation /google {\\n\\t\\treturn 302 https://www.google.com;\\n\\t}' /etc/nginx/sites-available/default" \
    --desc "Student adds 302 redirect for /google in default site configuration" \
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

# Step 4: Student queries /google and verifies 302 status code and Location header
student_exec "curl -i -s http://localhost/google" \
    --desc "Student verifies 302 redirect to google.com" \
    --expect-exit 0 \
    --expect-stdout "https://www.google.com"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: HTTP redirect configured successfully."
