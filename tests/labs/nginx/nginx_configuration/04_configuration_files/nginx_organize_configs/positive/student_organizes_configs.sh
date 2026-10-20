#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Organize Configs
# Module: nginx-configuration
# Section: 04-configuration-files
# Lab ID: nginx-organize-configs
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-organize-configs"

# Step 1: Student ensures conf.d directory exists
student_exec "mkdir -p /etc/nginx/conf.d" \
    --desc "Student ensures /etc/nginx/conf.d directory exists" \
    --expect-exit 0

# Step 2: Student creates upstream.conf
student_exec "cat << 'EOF' > /etc/nginx/conf.d/upstream.conf
upstream myapp {
    server 127.0.0.1:9000;
}
EOF" \
    --desc "Student creates modular upstream configuration file" \
    --expect-exit 0

# Step 3: Student verifies upstream.conf content
student_exec "cat /etc/nginx/conf.d/upstream.conf" \
    --desc "Student inspects upstream.conf content" \
    --expect-exit 0 \
    --expect-stdout "upstream myapp"

# Step 4: Student validates configuration syntax
student_exec "nginx -t" \
    --desc "Student tests nginx configuration syntax" \
    --expect-exit 0 \
    --expect-stderr "syntax is ok"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Configuration organized correctly under conf.d."
