#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Find package ownership for system binaries
# Module: linux-package-management
# Section: 04-package-information
# Lab ID: lnx-find-package-information
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-find-package-information"

# Step 1: Student queries package database for file ownership
student_exec "dpkg -S \$(which bash)" \
    --desc "Student traces package owning bash binary" \
    --expect-exit 0 \
    --expect-stdout "bash"

# Step 2: Student extracts package name and writes to bash_owner.txt
student_exec "dpkg -S \$(which bash) | head -n 1 | cut -d: -f1 > ~/pkg-test/bash_owner.txt" \
    --desc "Student saves owner package name" \
    --expect-exit 0

# Step 3: Student checks recorded owner name
student_exec "cat ~/pkg-test/bash_owner.txt" \
    --desc "Student verifies recorded owner package" \
    --expect-exit 0 \
    --expect-stdout "bash"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Package ownership traced successfully."
