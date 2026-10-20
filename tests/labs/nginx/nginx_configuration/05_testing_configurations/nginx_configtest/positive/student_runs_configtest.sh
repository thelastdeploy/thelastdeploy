#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Nginx Config Test
# Module: nginx-configuration
# Section: 05-testing-configurations
# Lab ID: nginx-configtest
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-configtest"

# Step 1: Student runs nginx configuration test and redirects output to /tmp/config_test_result.txt
student_exec "nginx -t > /tmp/config_test_result.txt 2>&1" \
    --desc "Student executes nginx -t and saves result to target file" \
    --expect-exit 0

# Step 2: Student inspects the saved test output
student_exec "cat /tmp/config_test_result.txt" \
    --desc "Student verifies saved test output" \
    --expect-exit 0 \
    --expect-stdout "syntax is ok"

# Step 3: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Configuration test successfully logged."
