#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Identify file owner and group
# Module: linux-users-permissions
# Section: 02-ownership
# Lab ID: lnx-check-owner
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-check-owner"

# Step 1: Student inspects the target file ownership with ls -l
student_exec "ls -l /tmp/ownership-check.txt" \
    --desc "Student inspects ownership columns in long listing format" \
    --expect-exit 0

# Step 2: Student queries ownership using stat format %U:%G
student_exec "stat -c '%U:%G' /tmp/ownership-check.txt" \
    --desc "Student inspects owner:group string with stat" \
    --expect-exit 0

# Step 3: Student redirects the stat ownership string into owner_info.txt
student_exec "stat -c '%U:%G' /tmp/ownership-check.txt > ~/ownership-test/owner_info.txt" \
    --desc "Student saves owner:group into ~/ownership-test/owner_info.txt" \
    --expect-exit 0

# Step 4: Student confirms the content of owner_info.txt
student_exec "cat ~/ownership-test/owner_info.txt" \
    --desc "Student verifies the saved ownership format" \
    --expect-exit 0

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Ownership correctly identified."
