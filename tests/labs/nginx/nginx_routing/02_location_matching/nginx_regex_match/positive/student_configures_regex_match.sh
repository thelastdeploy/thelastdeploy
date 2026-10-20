#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure Regex Match
# Module: nginx-routing
# Section: 02-location-matching
# Lab ID: nginx-regex-match
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-regex-match"

# Step 1: Student adds case-insensitive regex match location block
student_exec "sed -i '/server_name _;/a \\\tlocation ~* \\\\.(jpg|jpeg|png|gif)$ {\\n\\t\\troot /var/www/html;\\n\\t}' /etc/nginx/sites-available/default" \
    --desc "Student adds case-insensitive regex location matching image extensions" \
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

# Step 4: Student queries /test.PNG to verify regex matching works case-insensitively
student_exec "curl -s http://localhost/test.PNG" \
    --desc "Student verifies response from case-insensitive regex location" \
    --expect-exit 0 \
    --expect-stdout "regex test"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Regex location match configured correctly."
