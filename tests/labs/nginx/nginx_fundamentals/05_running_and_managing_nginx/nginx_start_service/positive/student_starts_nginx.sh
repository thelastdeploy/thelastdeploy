#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Start Nginx Service
# Module: nginx-fundamentals
# Section: 05-running-and-managing-nginx
# Lab ID: nginx-start-service
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-start-service"

# Step 1: Student ensures nginx package is installed in test container
student_exec "which nginx || (apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y nginx)" \
    --desc "Student ensures nginx package is installed in test container" \
    --expect-exit 0

# Step 2: Student checks initial status (service stopped)
student_exec "systemctl is-active nginx || true" \
    --desc "Student inspects initial inactive status" \
    --expect-exit 0

# Step 3: Student starts nginx service
student_exec "systemctl start nginx" \
    --desc "Student starts nginx service" \
    --expect-exit 0

# Step 4: Student confirms nginx service is active
student_exec "systemctl is-active nginx" \
    --desc "Student verifies nginx is active" \
    --expect-exit 0 \
    --expect-stdout "active"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Nginx service is active and running."
