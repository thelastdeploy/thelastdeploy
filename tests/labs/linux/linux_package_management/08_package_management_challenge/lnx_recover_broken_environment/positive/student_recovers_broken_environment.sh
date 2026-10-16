#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Recover broken package management environment
# Module: linux-package-management
# Section: 08-package-management-challenge
# Lab ID: lnx-recover-broken-environment
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-recover-broken-environment"

# Step 1: Student inspects the locks directory
student_exec "ls -la ~/pkg-challenge/locks" \
    --desc "Student inspects locks folder for stale lock file" \
    --expect-exit 0 \
    --expect-stdout "frontend.lock"

# Step 2: Student removes the stale frontend lock file
student_exec "rm -f ~/pkg-challenge/locks/frontend.lock" \
    --desc "Student removes stale lock file" \
    --expect-exit 0

# Step 3: Student inspects status.log for interrupted packages
student_exec "cat ~/pkg-challenge/status.log" \
    --desc "Student reads package status records" \
    --expect-exit 0 \
    --expect-stdout "half-configured"

# Step 4: Student extracts the half-configured package name
student_exec "grep 'half-configured' ~/pkg-challenge/status.log | awk '{print \$2}' > ~/pkg-challenge/recovered_package.txt" \
    --desc "Student saves recovered package name" \
    --expect-exit 0

# Step 5: Student verifies recovered package value
student_exec "cat ~/pkg-challenge/recovered_package.txt" \
    --desc "Student checks recorded recovered package" \
    --expect-exit 0 \
    --expect-stdout "app-service"

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Package environment recovered successfully!"
