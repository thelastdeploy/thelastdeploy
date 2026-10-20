#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix Upstream Port Mismatch
# Module: nginx-troubleshooting
# Section: 04-debugging-upstreams
# Lab ID: nginx-port-mismatch
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-port-mismatch"

# Step 1: Student corrects the upstream server port in configuration
student_exec "sudo sed -i 's|8088|8081|g' /etc/nginx/conf.d/upstream.conf" \
    --desc "Student updates upstream port to 8081" \
    --expect-exit 0

# Step 2: Student tests configuration syntax and reloads Nginx
student_exec "sudo nginx -t && sudo systemctl restart nginx" \
    --desc "Student tests syntax and reloads Nginx service" \
    --expect-exit 0

# Step 3: Student verifies response from /app through Nginx
student_exec "curl -s http://localhost/app" \
    --desc "Student verifies UPSTREAM OK response from upstream" \
    --expect-exit 0 \
    --expect-stdout "UPSTREAM OK"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Upstream port mismatch fixed successfully."
