#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure Exact Match
# Module: nginx-routing
# Section: 02-location-matching
# Lab ID: nginx-exact-match
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-exact-match"

# Step 1: Student adds exact match location block for /special.html
student_exec "sed -i '/server_name _;/a \\\tlocation = /special.html {\\n\\t\\troot /var/www/html;\\n\\t}' /etc/nginx/sites-available/default" \
    --desc "Student adds exact match location = /special.html" \
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

# Step 4: Student queries /special.html to verify exact match response
student_exec "curl -s http://localhost/special.html" \
    --desc "Student verifies response from exact match location" \
    --expect-exit 0 \
    --expect-stdout "exact test"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Exact match location configured correctly."
