#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Query installed packages database
# Module: linux-package-management
# Section: 01-package-management-basics
# Lab ID: lnx-inspect-installed-packages
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-inspect-installed-packages"

# Step 1: Student checks if bash package is installed
student_exec "dpkg -l bash || rpm -q bash" \
    --desc "Student queries package database for bash" \
    --expect-exit 0 \
    --expect-stdout "bash"

# Step 2: Student saves installed status to bash_status.txt
student_exec "echo 'installed' > ~/pkg-test/bash_status.txt" \
    --desc "Student records installed status in bash_status.txt" \
    --expect-exit 0

# Step 3: Student verifies recorded status
student_exec "cat ~/pkg-test/bash_status.txt" \
    --desc "Student verifies recorded status value" \
    --expect-exit 0 \
    --expect-stdout "installed"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Installed package status queried successfully."
