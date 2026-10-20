#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Stop Nginx Service
# Module: nginx-fundamentals
# Section: 05-running-and-managing-nginx
# Lab ID: nginx-stop-service
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-stop-service"

# Step 1: Student ensures nginx package is installed in test container and running
student_exec "which nginx || (apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y nginx)" \
    --desc "Student ensures nginx package is installed in test container" \
    --expect-exit 0

student_exec "systemctl start nginx || true" \
    --desc "Student ensures nginx service is initially running" \
    --expect-exit 0

# Step 2: Student verifies nginx is currently active
student_exec "systemctl is-active nginx" \
    --desc "Student verifies nginx is initially active" \
    --expect-exit 0 \
    --expect-stdout "active"

# Step 3: Student stops nginx service
student_exec "systemctl stop nginx" \
    --desc "Student stops nginx service" \
    --expect-exit 0

# Step 4: Student confirms nginx service is no longer active
student_exec "systemctl is-active nginx || true" \
    --desc "Student confirms nginx is stopped" \
    --expect-exit 0

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Nginx service is stopped."
