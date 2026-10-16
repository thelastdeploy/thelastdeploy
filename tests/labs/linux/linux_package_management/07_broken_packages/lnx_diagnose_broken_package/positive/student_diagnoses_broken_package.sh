#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Diagnose half-installed broken package status
# Module: linux-package-management
# Section: 07-broken-packages
# Lab ID: lnx-diagnose-broken-package
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-diagnose-broken-package"

# Step 1: Student inspects the dpkg status log
student_exec "cat ~/broken-test/dpkg_status.log" \
    --desc "Student inspects dpkg status records" \
    --expect-exit 0 \
    --expect-stdout "half-installed"

# Step 2: Student extracts the half-installed package name
student_exec "grep 'half-installed' ~/broken-test/dpkg_status.log | awk '{print \$2}' > ~/broken-test/broken_package.txt" \
    --desc "Student isolates and saves broken package name" \
    --expect-exit 0

# Step 3: Student verifies recorded package name
student_exec "cat ~/broken-test/broken_package.txt" \
    --desc "Student verifies recorded broken package" \
    --expect-exit 0 \
    --expect-stdout "custom-app"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Broken package status diagnosed successfully."
