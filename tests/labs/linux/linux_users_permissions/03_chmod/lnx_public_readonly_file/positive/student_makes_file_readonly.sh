#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Setup a public read-only file
# Module: linux-users-permissions
# Section: 03-chmod
# Lab ID: lnx-public-readonly-file
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-public-readonly-file"

# Step 1: Student inspects existing permissions on readme.txt
student_exec "ls -l ~/chmod-test/readme.txt" \
    --desc "Student inspects permissive 777 mode on readme.txt" \
    --expect-exit 0

# Step 2: Student restricts file permissions to 644 (rw-r--r--)
student_exec "chmod 644 ~/chmod-test/readme.txt" \
    --desc "Student sets mode 644 on readme.txt using chmod" \
    --expect-exit 0

# Step 3: Student verifies octal permissions with stat
student_exec "stat -c '%a' ~/chmod-test/readme.txt" \
    --desc "Student verifies octal permissions are 644" \
    --expect-exit 0 \
    --expect-stdout "644"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Public read-only permissions configured successfully."
