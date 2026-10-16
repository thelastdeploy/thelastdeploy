#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure SUID on a helper utility
# Module: linux-users-permissions
# Section: 04-special-permissions
# Lab ID: lnx-setuid-lab
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-setuid-lab"

# Step 1: Student inspects current permissions on the helper executable
student_exec "ls -l ~/special-test/suid-helper" \
    --desc "Student inspects permissions on suid-helper" \
    --expect-exit 0

# Step 2: Student sets the SUID bit while preserving 755 mode
student_exec "chmod u+s ~/special-test/suid-helper" \
    --desc "Student sets SUID bit with chmod u+s" \
    --expect-exit 0

# Step 3: Student verifies the file has SUID set
student_exec "test -u ~/special-test/suid-helper && echo 'SUID active'" \
    --desc "Student tests for SUID bit using test -u" \
    --expect-exit 0 \
    --expect-stdout "SUID active"

# Step 4: Student confirms permissions string representation
student_exec "stat -c '%a' ~/special-test/suid-helper" \
    --desc "Student verifies octal representation is 4755" \
    --expect-exit 0 \
    --expect-stdout "4755"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: SUID bit successfully configured on helper executable."
