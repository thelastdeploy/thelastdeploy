#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Include Config
# Module: nginx-configuration
# Section: 04-configuration-files
# Lab ID: nginx-include-config
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-include-config"

# Step 1: Student ensures default site exists
student_exec "test -f /etc/nginx/sites-available/default" \
    --desc "Student checks default site configuration exists" \
    --expect-exit 0

# Step 2: Student inspects custom snippet
student_exec "cat /etc/nginx/snippets/custom-headers.conf" \
    --desc "Student inspects custom-headers snippet" \
    --expect-exit 0 \
    --expect-stdout "X-Custom-Header"

# Step 3: Student includes snippet inside default site configuration
student_exec "sed -i '/server_name _;/a \    include /etc/nginx/snippets/custom-headers.conf;' /etc/nginx/sites-available/default" \
    --desc "Student includes snippet in default site configuration" \
    --expect-exit 0

# Step 4: Student validates configuration syntax
student_exec "nginx -t" \
    --desc "Student validates nginx configuration syntax" \
    --expect-exit 0 \
    --expect-stderr "syntax is ok"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Configuration snippet successfully included."
