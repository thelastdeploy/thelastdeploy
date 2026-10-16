#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Verify required package installation
# Module: linux-package-management
# Section: 02-installing-packages
# Lab ID: lnx-install-required-package
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-install-required-package"

# Step 1: Student verifies curl binary presence
student_exec "which curl" \
    --desc "Student locates curl binary" \
    --expect-exit 0 \
    --expect-stdout "curl"

# Step 2: Student saves curl path to curl_path.txt
student_exec "which curl > ~/pkg-test/curl_path.txt" \
    --desc "Student saves curl executable path" \
    --expect-exit 0

# Step 3: Student checks recorded path
student_exec "cat ~/pkg-test/curl_path.txt" \
    --desc "Student verifies recorded path" \
    --expect-exit 0 \
    --expect-stdout "curl"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Required package path verified."
