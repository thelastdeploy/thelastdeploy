#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Reload Nginx Service
# Module: nginx-fundamentals
# Section: 05-running-and-managing-nginx
# Lab ID: nginx-reload-service
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-reload-service"

# Step 1: Student ensures nginx package is installed in test container and active
student_exec "which nginx || (apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y nginx)" \
    --desc "Student ensures nginx package is installed in test container" \
    --expect-exit 0

student_exec "systemctl start nginx || true" \
    --desc "Student ensures nginx service is active" \
    --expect-exit 0

# Step 2: Student tests configuration syntax before reloading
student_exec "nginx -t" \
    --desc "Student tests nginx configuration syntax" \
    --expect-exit 0 \
    --expect-stderr "syntax is ok"

# Step 3: Student reloads nginx service cleanly
student_exec "systemctl reload nginx" \
    --desc "Student reloads nginx service" \
    --expect-exit 0

# Step 4: Student confirms nginx remains active after reload
student_exec "systemctl is-active nginx" \
    --desc "Student verifies nginx remains active" \
    --expect-exit 0 \
    --expect-stdout "active"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Nginx configuration is valid and service is running."
