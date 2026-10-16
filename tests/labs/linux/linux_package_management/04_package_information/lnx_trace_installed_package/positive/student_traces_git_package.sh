#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Trace package owning target binary
# Module: linux-package-management
# Section: 04-package-information
# Lab ID: lnx-trace-installed-package
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-trace-installed-package"

# Step 1: Student inspects the mock package query log
student_exec "cat ~/pkg-test/pkg_query.log" \
    --desc "Student inspects pkg_query.log" \
    --expect-exit 0 \
    --expect-stdout "/usr/bin/git"

# Step 2: Student extracts package name owning /usr/bin/git
student_exec "grep '/usr/bin/git' ~/pkg-test/pkg_query.log | awk '{print \$2}' > ~/pkg-test/git_package.txt" \
    --desc "Student extracts and saves git package name" \
    --expect-exit 0

# Step 3: Student verifies recorded package name
student_exec "cat ~/pkg-test/git_package.txt" \
    --desc "Student checks recorded package value" \
    --expect-exit 0 \
    --expect-stdout "git"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Installed package traced successfully."
