#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Enable Server Block
# Module: nginx-configuration
# Section: 03-server-blocks
# Lab ID: nginx-enable-server-block
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-enable-server-block"

# Step 1: Student ensures directories exist and configuration file is present
student_exec "mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled" \
    --desc "Student ensures nginx configuration directories exist" \
    --expect-exit 0

student_exec "test -f /etc/nginx/sites-available/mysite" \
    --desc "Student confirms mysite configuration file exists in sites-available" \
    --expect-exit 0

# Step 2: Student creates symbolic link in sites-enabled
student_exec "ln -sf /etc/nginx/sites-available/mysite /etc/nginx/sites-enabled/mysite" \
    --desc "Student creates symbolic link to enable mysite" \
    --expect-exit 0

# Step 3: Student verifies symlink target
student_exec "readlink -f /etc/nginx/sites-enabled/mysite" \
    --desc "Student verifies symlink target path" \
    --expect-exit 0 \
    --expect-stdout "/etc/nginx/sites-available/mysite"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Server block symlink is valid."
