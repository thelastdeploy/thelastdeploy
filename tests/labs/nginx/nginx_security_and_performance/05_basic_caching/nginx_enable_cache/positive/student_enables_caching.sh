#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure Proxy Caching
# Module: nginx-security-and-performance
# Section: 05-basic-caching
# Lab ID: nginx-enable-cache
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-enable-cache"

# Step 1: Student defines proxy_cache_path in /etc/nginx/nginx.conf
student_exec "sed -i '/http {/a \\\tproxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m inactive=60m;' /etc/nginx/nginx.conf" \
    --desc "Student defines proxy_cache_path in nginx.conf" \
    --expect-exit 0

# Step 2: Student enables proxy_cache and proxy_cache_valid inside location /app in default site
student_exec "sed -i '/location \\/app {/a \\\t\\tproxy_cache my_cache;\\n\\t\\tproxy_cache_valid 200 10m;' /etc/nginx/sites-available/default" \
    --desc "Student adds caching directives inside location /app" \
    --expect-exit 0

# Step 3: Student validates nginx configuration syntax
student_exec "nginx -t" \
    --desc "Student verifies nginx configuration syntax" \
    --expect-exit 0 \
    --expect-stderr "syntax is ok"

# Step 4: Student reloads nginx
student_exec "systemctl restart nginx" \
    --desc "Student reloads nginx service" \
    --expect-exit 0

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Proxy caching configured successfully."
