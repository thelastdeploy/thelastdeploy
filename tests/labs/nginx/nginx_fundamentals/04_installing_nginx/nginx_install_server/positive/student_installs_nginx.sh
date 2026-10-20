#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Install Nginx Server
# Module: nginx-fundamentals
# Section: 04-installing-nginx
# Lab ID: nginx-install-server
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-install-server"

# Step 1: Student checks initial state
student_exec "which nginx || command -v nginx || true" \
    --desc "Student checks initial nginx binary availability" \
    --expect-exit 0

# Step 2: Student updates package repositories
student_exec "apt-get update" \
    --desc "Student updates package index" \
    --expect-exit 0

# Step 3: Student installs nginx package
student_exec "DEBIAN_FRONTEND=noninteractive apt-get install -y nginx" \
    --desc "Student installs nginx web server" \
    --expect-exit 0

# Step 4: Student locates nginx binary in PATH
student_exec "which nginx" \
    --desc "Student verifies nginx binary location" \
    --expect-exit 0 \
    --expect-stdout "/usr/sbin/nginx"

# Step 5: Student checks nginx version
student_exec "nginx -v" \
    --desc "Student checks nginx version" \
    --expect-exit 0

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Nginx is successfully installed"
