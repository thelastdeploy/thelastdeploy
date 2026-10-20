#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix Broken Installation
# Module: nginx-fundamentals
# Section: 07-recover-a-broken-installation
# Lab ID: nginx-fix-installation
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-fix-installation"

# Step 1: Student checks initial state and observes configuration failure
student_exec "nginx -t || true" \
    --desc "Student identifies syntax error with nginx -t" \
    --expect-exit 0 \
    --expect-stderr "broken_syntax_here"

# Step 2: Student removes broken syntax directive from configuration
student_exec "sed -i 's/ broken_syntax_here//g' /etc/nginx/sites-available/default" \
    --desc "Student removes broken syntax directive" \
    --expect-exit 0

# Step 3: Student re-tests nginx configuration syntax
student_exec "nginx -t" \
    --desc "Student re-tests nginx configuration" \
    --expect-exit 0 \
    --expect-stderr "syntax is ok"

# Step 4: Student starts nginx service
student_exec "systemctl start nginx" \
    --desc "Student starts nginx service" \
    --expect-exit 0

# Step 5: Student confirms nginx is running
student_exec "systemctl is-active nginx" \
    --desc "Student verifies nginx is active" \
    --expect-exit 0 \
    --expect-stdout "active"

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Configuration fixed and Nginx successfully running!"
