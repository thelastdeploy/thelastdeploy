#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Debug Config Conflict
# Module: nginx-configuration
# Section: 07-fix-a-broken-configuration
# Lab ID: nginx-debug-config
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-debug-config"

# Step 1: Student checks initial state and observes duplicate default server error
student_exec "nginx -t || true" \
    --desc "Student identifies conflicting directive with nginx -t" \
    --expect-exit 0 \
    --expect-stderr "duplicate default server"

# Step 2: Student removes conflicting duplicate site symlink
student_exec "rm -f /etc/nginx/sites-enabled/duplicate-default" \
    --desc "Student removes conflicting site from sites-enabled" \
    --expect-exit 0

# Step 3: Student re-tests configuration syntax
student_exec "nginx -t" \
    --desc "Student verifies nginx configuration syntax is now valid" \
    --expect-exit 0 \
    --expect-stderr "syntax is ok"

# Step 4: Student starts nginx service
student_exec "systemctl start nginx" \
    --desc "Student starts nginx service" \
    --expect-exit 0

# Step 5: Student confirms nginx is active
student_exec "systemctl is-active nginx" \
    --desc "Student confirms nginx service is active" \
    --expect-exit 0 \
    --expect-stdout "active"

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Configuration conflict successfully resolved and Nginx started."
