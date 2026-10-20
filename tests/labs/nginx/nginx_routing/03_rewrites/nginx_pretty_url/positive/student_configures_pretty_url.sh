#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure Pretty URL Rewrite
# Module: nginx-routing
# Section: 03-rewrites
# Lab ID: nginx-pretty-url
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-pretty-url"

# Step 1: Student adds rewrite rule for /products/([0-9]+) to /product.html?id=$1
student_exec "sed -i '/server_name _;/a \\\trewrite ^/products/([0-9]+)$ /product.html?id=\$1 last;' /etc/nginx/sites-available/default" \
    --desc "Student adds pretty URL rewrite rule to default site configuration" \
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

# Step 4: Student queries /products/123 to verify rewritten response
student_exec "curl -i -s http://localhost/products/123" \
    --desc "Student verifies pretty URL rewrite serves product page" \
    --expect-exit 0 \
    --expect-stdout "product page"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Pretty URL rewrite configured successfully."
