#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Enable WebSocket Proxy
# Module: nginx-reverse-proxy
# Section: 05-websocket-support
# Lab ID: nginx-enable-websocket-proxy
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-enable-websocket-proxy"

# Step 1: Student adds location /ws with WebSocket proxy and upgrade directives
student_exec "sed -i '/server_name _;/a \\\tlocation /ws {\\n\\t\\tproxy_pass http://127.0.0.1:9000;\\n\\t\\tproxy_http_version 1.1;\\n\\t\\tproxy_set_header Upgrade \\\$http_upgrade;\\n\\t\\tproxy_set_header Connection \"upgrade\";\\n\\t}' /etc/nginx/sites-available/default" \
    --desc "Student configures WebSocket reverse proxy location" \
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
    --expect-stdout "PASS: WebSocket connection upgrade proxying configured successfully."
