#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Recover Production Outage
# Module: nginx-troubleshooting
# Section: 06-recover-a-production-nginx-server
# Lab ID: nginx-production-outage
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-production-outage"

# Step 1: Student restores missing semicolon in nginx.conf
student_exec "sudo sed -i 's/keepalive_timeout 65/keepalive_timeout 65;/g' /etc/nginx/nginx.conf" \
    --desc "Student adds missing semicolon to keepalive_timeout directive" \
    --expect-exit 0

# Step 2: Student corrects invalid proxy_pass scheme in default site config
student_exec "sudo sed -i 's|ht://127.0.0.1:8080|http://127.0.0.1:8080|g' /etc/nginx/sites-available/default" \
    --desc "Student corrects proxy_pass URL scheme to http://" \
    --expect-exit 0

# Step 3: Student removes duplicate default_server declaration
student_exec "sudo sed -i '0,/listen 80 default_server/! s/listen 80 default_server;/listen 80;/' /etc/nginx/sites-available/default" \
    --desc "Student removes duplicate default_server from secondary server block" \
    --expect-exit 0

# Step 4: Student tests syntax and starts Nginx service
student_exec "sudo nginx -t && sudo systemctl start nginx" \
    --desc "Student validates configuration and starts Nginx service" \
    --expect-exit 0

# Step 5: Student confirms service is active
student_exec "systemctl is-active --quiet nginx" \
    --desc "Student verifies Nginx service is running" \
    --expect-exit 0

# Step 6: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Production outage recovered successfully."
