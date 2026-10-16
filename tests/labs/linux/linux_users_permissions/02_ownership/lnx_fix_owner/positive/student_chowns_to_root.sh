#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Change file ownership
# Module: linux-users-permissions
# Section: 02-ownership
# Lab ID: lnx-fix-owner
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-fix-owner"

# Step 1: Student inspects the initial ownership of admin-file.txt
student_exec "ls -l ~/ownership-test/admin-file.txt" \
    --desc "Student inspects current ownership with ls -l" \
    --expect-exit 0

# Step 2: Student changes owner and group to root using sudo chown root:root
student_exec "sudo chown root:root ~/ownership-test/admin-file.txt" \
    --desc "Student updates file ownership to root:root via sudo chown" \
    --expect-exit 0

# Step 3: Student verifies the updated ownership with stat
student_exec "stat -c '%U:%G' ~/ownership-test/admin-file.txt" \
    --desc "Student confirms the new ownership using stat" \
    --expect-exit 0 \
    --expect-stdout "root:root"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: File ownership successfully changed to root:root."
