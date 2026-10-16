#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Identify upgradable outdated packages
# Module: linux-package-management
# Section: 03-updating-and-removing
# Lab ID: lnx-manage-outdated-packages
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-manage-outdated-packages"

# Step 1: Student inspects the mock package manager log
student_exec "cat ~/pkg-test/upgrades.log" \
    --desc "Student inspects upgrades log" \
    --expect-exit 0 \
    --expect-stdout "upgradable"

# Step 2: Student counts upgradable packages using grep -c
student_exec "grep -c 'upgradable' ~/pkg-test/upgrades.log > ~/pkg-test/upgradable_count.txt" \
    --desc "Student saves count of upgradable packages" \
    --expect-exit 0

# Step 3: Student verifies recorded count
student_exec "cat ~/pkg-test/upgradable_count.txt" \
    --desc "Student checks recorded count value" \
    --expect-exit 0 \
    --expect-stdout "3"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Upgradable package count verified."
