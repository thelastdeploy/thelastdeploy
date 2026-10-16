#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Protect a directory with the Sticky Bit
# Module: linux-users-permissions
# Section: 04-special-permissions
# Lab ID: lnx-sticky-bit-lab
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-sticky-bit-lab"

# Step 1: Student inspects the permissions of the directory
student_exec "ls -ld ~/special-test/sticky-dir" \
    --desc "Student inspects directory permissions with ls -ld" \
    --expect-exit 0

# Step 2: Student sets the Sticky Bit on the directory
student_exec "chmod +t ~/special-test/sticky-dir" \
    --desc "Student applies the Sticky Bit using chmod +t" \
    --expect-exit 0

# Step 3: Student verifies the directory has the Sticky Bit active
student_exec "test -k ~/special-test/sticky-dir && echo 'Sticky active'" \
    --desc "Student tests for Sticky Bit using test -k" \
    --expect-exit 0 \
    --expect-stdout "Sticky active"

# Step 4: Student confirms octal representation includes leading 1
student_exec "stat -c '%a' ~/special-test/sticky-dir" \
    --desc "Student verifies octal representation is 1777" \
    --expect-exit 0 \
    --expect-stdout "1777"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Sticky Bit configured successfully."
