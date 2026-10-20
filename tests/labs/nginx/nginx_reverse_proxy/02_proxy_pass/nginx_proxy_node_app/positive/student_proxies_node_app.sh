#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Proxy Node App
# Module: nginx-reverse-proxy
# Section: 02-proxy-pass
# Lab ID: nginx-proxy-node-app
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-proxy-node-app"

# Step 1: Student adds location /node with proxy_pass http://127.0.0.1:3000
student_exec "sed -i '/server_name _;/a \\\tlocation /node {\\n\\t\\tproxy_pass http://127.0.0.1:3000;\\n\\t}' /etc/nginx/sites-available/default" \
    --desc "Student configures location /node proxying to Node backend" \
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

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Node app proxy pass configured successfully."
