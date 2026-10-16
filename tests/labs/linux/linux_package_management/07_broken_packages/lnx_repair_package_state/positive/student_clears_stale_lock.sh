#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Resolve stale package manager lock files
# Module: linux-package-management
# Section: 07-broken-packages
# Lab ID: lnx-repair-package-state
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-repair-package-state"

# Step 1: Student inspects the lock zone directory
student_exec "ls -la ~/broken-test/lock_zone" \
    --desc "Student inspects lock files directory" \
    --expect-exit 0 \
    --expect-stdout "dpkg_lock.lock"

# Step 2: Student removes the stale lock file
student_exec "rm -f ~/broken-test/lock_zone/dpkg_lock.lock" \
    --desc "Student removes stale dpkg_lock.lock" \
    --expect-exit 0

# Step 3: Student verifies lock file is gone
student_exec "ls -la ~/broken-test/lock_zone" \
    --desc "Student confirms lock file is removed" \
    --expect-exit 0

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Stale package manager lock file cleared successfully!"
