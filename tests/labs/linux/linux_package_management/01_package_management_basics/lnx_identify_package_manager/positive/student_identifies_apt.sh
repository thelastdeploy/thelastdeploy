#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Identify active system package manager
# Module: linux-package-management
# Section: 01-package-management-basics
# Lab ID: lnx-identify-package-manager
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-identify-package-manager"

# Step 1: Student checks for apt or dnf
student_exec "command -v apt || command -v dnf" \
    --desc "Student inspects system for package manager binary" \
    --expect-exit 0 \
    --expect-stdout "apt"

# Step 2: Student saves the active package manager to pkg_manager.txt
student_exec "(command -v dnf &>/dev/null && echo 'dnf' || echo 'apt') > ~/pkg-test/pkg_manager.txt" \
    --desc "Student writes package manager name to pkg_manager.txt" \
    --expect-exit 0

# Step 3: Student verifies recorded package manager
student_exec "cat ~/pkg-test/pkg_manager.txt" \
    --desc "Student verifies recorded package manager" \
    --expect-exit 0 \
    --expect-stdout "apt"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Active package manager identified successfully."
