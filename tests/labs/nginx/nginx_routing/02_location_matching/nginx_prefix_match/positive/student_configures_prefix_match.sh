#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure Prefix Match
# Module: nginx-routing
# Section: 02-location-matching
# Lab ID: nginx-prefix-match
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-prefix-match"

# Step 1: Student adds prefix location block for /docs
student_exec "sed -i '/server_name _;/a \\\tlocation /docs/ {\\n\\t\\talias /var/www/docs/;\\n\\t}' /etc/nginx/sites-available/default" \
    --desc "Student adds prefix location /docs/ to default site configuration" \
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

# Step 4: Student queries /docs/ to verify content is served
student_exec "curl -s http://localhost/docs/" \
    --desc "Student verifies response from prefix location" \
    --expect-exit 0 \
    --expect-stdout "prefix test"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Prefix match location configured correctly."
