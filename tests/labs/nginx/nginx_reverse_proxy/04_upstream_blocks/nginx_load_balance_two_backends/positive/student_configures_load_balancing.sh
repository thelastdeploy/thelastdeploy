#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Load Balance Backends
# Module: nginx-reverse-proxy
# Section: 04-upstream-blocks
# Lab ID: nginx-load-balance-two-backends
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-load-balance-two-backends"

# Step 1: Student adds location /app proxying to backend_servers upstream
student_exec "sed -i '/server_name _;/a \\\tlocation /app {\\n\\t\\tproxy_pass http://backend_servers;\\n\\t}' /etc/nginx/sites-available/default" \
    --desc "Student configures location /app to proxy to backend_servers" \
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
    --expect-stdout "PASS: Load balancing reverse proxy configured successfully."
