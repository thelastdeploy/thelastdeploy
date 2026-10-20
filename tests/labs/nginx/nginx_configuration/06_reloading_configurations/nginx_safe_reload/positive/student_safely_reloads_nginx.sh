#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Safe Reload Nginx
# Module: nginx-configuration
# Section: 06-reloading-configurations
# Lab ID: nginx-safe-reload
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-safe-reload"

# Step 1: Student checks initial state and confirms port 8085 is not yet active
student_exec "curl -s --connect-timeout 2 http://localhost:8085/ || true" \
    --desc "Student observes port 8085 is not responding before reload" \
    --expect-exit 0

# Step 2: Student tests configuration syntax
student_exec "nginx -t" \
    --desc "Student tests nginx configuration syntax" \
    --expect-exit 0 \
    --expect-stderr "syntax is ok"

# Step 3: Student reloads nginx service gracefully
student_exec "systemctl reload nginx" \
    --desc "Student reloads nginx service" \
    --expect-exit 0

# Step 4: Student confirms port 8085 is now actively responding
student_exec "curl -s --connect-timeout 2 http://localhost:8085/" \
    --desc "Student queries port 8085 after reload" \
    --expect-exit 0

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Configuration successfully reloaded and listening on port 8085."
