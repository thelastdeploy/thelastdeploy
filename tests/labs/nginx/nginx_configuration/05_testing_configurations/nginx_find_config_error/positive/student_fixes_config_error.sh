#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Find Config Error
# Module: nginx-configuration
# Section: 05-testing-configurations
# Lab ID: nginx-find-config-error
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-find-config-error"

# Step 1: Student runs config test to observe the error
student_exec "nginx -t || true" \
    --desc "Student observes configuration syntax failure" \
    --expect-exit 0

# Step 2: Student repairs missing semicolon on root directive
student_exec "sed -i 's/root \\/var\\/www\\/html\$/root \\/var\\/www\\/html;/' /etc/nginx/sites-available/default" \
    --desc "Student restores missing semicolon on root directive" \
    --expect-exit 0

# Step 3: Student verifies configuration test passes
student_exec "nginx -t" \
    --desc "Student re-tests configuration" \
    --expect-exit 0 \
    --expect-stderr "syntax is ok"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Configuration test passes. Syntax error fixed."
