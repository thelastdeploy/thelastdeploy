#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Investigate package dependency requirements
# Module: linux-package-management
# Section: 05-dependencies
# Lab ID: lnx-investigate-package-dependencies
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-investigate-package-dependencies"

# Step 1: Student inspects the dependency log
student_exec "cat ~/pkg-test/deps.log" \
    --desc "Student inspects deps.log for package dependencies" \
    --expect-exit 0 \
    --expect-stdout "libssl-dev"

# Step 2: Student isolates the libssl dependency package name
student_exec "grep 'libssl' ~/pkg-test/deps.log | awk '{print \$2}' > ~/pkg-test/req_dep.txt" \
    --desc "Student extracts and saves required dependency package name" \
    --expect-exit 0

# Step 3: Student verifies recorded dependency name
student_exec "cat ~/pkg-test/req_dep.txt" \
    --desc "Student verifies recorded dependency value" \
    --expect-exit 0 \
    --expect-stdout "libssl-dev"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Package dependency investigated successfully."
