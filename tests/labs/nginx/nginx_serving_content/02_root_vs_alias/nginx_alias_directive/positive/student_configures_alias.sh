#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure Alias Directive
# Module: nginx-serving-content
# Section: 02-root-vs-alias
# Lab ID: nginx-alias-directive
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-alias-directive"

# Step 1: Student ensures default site exists
student_exec "test -f /etc/nginx/sites-available/default" \
    --desc "Student checks default site configuration exists" \
    --expect-exit 0

# Step 2: Student adds /assets/ location block with alias directive
student_exec "sed -i '/server_name _;/a \    location /assets/ {\n        alias /var/www/static/media/;\n    }' /etc/nginx/sites-available/default" \
    --desc "Student configures /assets/ location block with alias directive" \
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

# Step 5: Student tests static file response
student_exec "curl -s http://localhost/assets/test.txt" \
    --desc "Student fetches static file via alias directive" \
    --expect-exit 0 \
    --expect-stdout "alias test"

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Location /assets/ alias path configured correctly."
