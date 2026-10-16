#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Make a script executable
# Module: linux-users-permissions
# Section: 03-chmod
# Lab ID: lnx-basic-chmod
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-basic-chmod"

# Step 1: Student inspects current file permissions
student_exec "ls -l ~/chmod-test/script.sh" \
    --desc "Student inspects existing script permissions" \
    --expect-exit 0

# Step 2: Student updates permissions to 755 (rwxr-xr-x)
student_exec "chmod 755 ~/chmod-test/script.sh" \
    --desc "Student sets mode 755 on script.sh using chmod" \
    --expect-exit 0

# Step 3: Student verifies octal permissions with stat
student_exec "stat -c '%a' ~/chmod-test/script.sh" \
    --desc "Student verifies octal permissions are 755" \
    --expect-exit 0 \
    --expect-stdout "755"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Script file is now executable by everyone and writable only by the owner."
