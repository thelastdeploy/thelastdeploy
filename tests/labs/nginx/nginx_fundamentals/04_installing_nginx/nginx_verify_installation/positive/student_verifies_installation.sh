#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Verify Nginx Installation
# Module: nginx-fundamentals
# Section: 04-installing-nginx
# Lab ID: nginx-verify-installation
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-verify-installation"

# Step 1: Student ensures nginx package is installed in test container
student_exec "which nginx || (apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y nginx)" \
    --desc "Student ensures nginx package is installed in test container" \
    --expect-exit 0

# Step 2: Student checks /etc/nginx directory exists
student_exec "test -d /etc/nginx" \
    --desc "Student checks /etc/nginx directory exists" \
    --expect-exit 0

# Step 3: Student inspects /etc/nginx directory contents
student_exec "ls -la /etc/nginx" \
    --desc "Student inspects /etc/nginx configuration structure" \
    --expect-exit 0 \
    --expect-stdout "nginx.conf"

# Step 4: Student views head of main nginx.conf
student_exec "head -n 5 /etc/nginx/nginx.conf" \
    --desc "Student views head of main nginx.conf" \
    --expect-exit 0

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Nginx configuration directory verified."
