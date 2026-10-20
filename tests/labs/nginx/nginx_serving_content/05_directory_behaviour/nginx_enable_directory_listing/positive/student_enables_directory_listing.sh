#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Enable Directory Listing
# Module: nginx-serving-content
# Section: 05-directory-behaviour
# Lab ID: nginx-enable-directory-listing
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-enable-directory-listing"

# Step 1: Student adds location /downloads/ with autoindex on to default site configuration
student_exec "sed -i '/server_name _;/a \\\tlocation /downloads/ {\\n\\t\\tautoindex on;\\n\\t}' /etc/nginx/sites-available/default" \
    --desc "Student adds location block with autoindex on for /downloads/" \
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

# Step 4: Student queries /downloads/ to verify directory listing is active
student_exec "curl -s http://localhost/downloads/" \
    --desc "Student verifies directory listing response contains downloads index and package file" \
    --expect-exit 0 \
    --expect-stdout "Index of /downloads/"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Directory listing enabled for /downloads/ successfully."
