#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure Temporary Redirect
# Module: nginx-routing
# Section: 04-redirects
# Lab ID: nginx-temporary-redirect
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-temporary-redirect"

# Step 1: Student adds location /promo redirecting temporarily to /landing-page
student_exec "sed -i '/server_name _;/a \\\tlocation /promo {\\n\\t\\treturn 302 /landing-page;\\n\\t}' /etc/nginx/sites-available/default" \
    --desc "Student adds 302 redirect for /promo in default site configuration" \
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

# Step 4: Student queries /promo and verifies 302 status code and Location header
student_exec "curl -i -s http://localhost/promo" \
    --desc "Student verifies 302 temporary redirect to /landing-page" \
    --expect-exit 0 \
    --expect-stdout "/landing-page"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Temporary redirect configured successfully."
