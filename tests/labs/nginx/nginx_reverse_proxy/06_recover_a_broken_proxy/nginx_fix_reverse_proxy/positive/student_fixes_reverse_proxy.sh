#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix Broken Reverse Proxy
# Module: nginx-reverse-proxy
# Section: 06-recover-a-broken-proxy
# Lab ID: nginx-fix-reverse-proxy
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-fix-reverse-proxy"

# Step 1: Student runs nginx -t and observes syntax failure due to missing scheme
student_exec "nginx -t" \
    --desc "Student observes syntax error from missing URL scheme" \
    --expect-exit 1

# Step 2: Student repairs proxy_pass target to include http:// prefix
student_exec "sed -i 's/proxy_pass 127.0.0.1:8080;/proxy_pass http:\\/\\/127.0.0.1:8080;/' /etc/nginx/sites-available/default" \
    --desc "Student adds http:// scheme to proxy_pass target" \
    --expect-exit 0

# Step 3: Student verifies nginx configuration syntax passes
student_exec "nginx -t" \
    --desc "Student verifies nginx configuration syntax" \
    --expect-exit 0 \
    --expect-stderr "syntax is ok"

# Step 4: Student starts nginx service
student_exec "systemctl start nginx || nginx" \
    --desc "Student starts nginx service" \
    --expect-exit 0

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Reverse proxy URL syntax error fixed successfully."
