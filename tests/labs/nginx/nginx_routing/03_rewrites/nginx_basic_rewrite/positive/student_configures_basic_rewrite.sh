#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure Basic Rewrite
# Module: nginx-routing
# Section: 03-rewrites
# Lab ID: nginx-basic-rewrite
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-basic-rewrite"

# Step 1: Student adds internal rewrite rule from /oldpath/file.html to /newpath/file.html
student_exec "sed -i '/server_name _;/a \\\trewrite ^/oldpath/file.html$ /newpath/file.html last;' /etc/nginx/sites-available/default" \
    --desc "Student adds basic rewrite rule to default site configuration" \
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

# Step 4: Student queries /oldpath/file.html and verifies internal rewrite returns new content with 200 OK
student_exec "curl -i -s http://localhost/oldpath/file.html" \
    --desc "Student verifies response from rewritten URL" \
    --expect-exit 0 \
    --expect-stdout "new content"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Basic internal rewrite configured successfully."
