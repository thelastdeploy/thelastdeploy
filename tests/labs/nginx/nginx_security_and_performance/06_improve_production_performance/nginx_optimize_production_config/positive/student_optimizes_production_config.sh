#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Optimize Production Configuration
# Module: nginx-security-and-performance
# Section: 06-improve-production-performance
# Lab ID: nginx-optimize-production-config
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-optimize-production-config"

# Step 1: Student sets worker_processes to auto
student_exec "sed -i 's/worker_processes.*/worker_processes auto;/' /etc/nginx/nginx.conf" \
    --desc "Student sets worker_processes to auto in nginx.conf" \
    --expect-exit 0

# Step 2: Student sets keepalive_timeout to 65
student_exec "sed -i 's/keepalive_timeout.*/keepalive_timeout 65;/' /etc/nginx/nginx.conf" \
    --desc "Student sets keepalive_timeout to 65 in nginx.conf" \
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
    --expect-stdout "PASS: Production configuration optimized successfully."
