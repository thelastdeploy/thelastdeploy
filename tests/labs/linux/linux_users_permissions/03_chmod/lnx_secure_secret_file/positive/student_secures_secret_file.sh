#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Secure private credentials
# Module: linux-users-permissions
# Section: 03-chmod
# Lab ID: lnx-secure-secret-file
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-secure-secret-file"

# Step 1: Student inspects existing permissions on secret.txt
student_exec "ls -l ~/chmod-test/secret.txt" \
    --desc "Student inspects permissions on secret.txt" \
    --expect-exit 0

# Step 2: Student restricts file permissions to 600 (rw-------)
student_exec "chmod 600 ~/chmod-test/secret.txt" \
    --desc "Student sets mode 600 on secret.txt using chmod" \
    --expect-exit 0

# Step 3: Student verifies octal permissions with stat
student_exec "stat -c '%a' ~/chmod-test/secret.txt" \
    --desc "Student verifies octal permissions are 600" \
    --expect-exit 0 \
    --expect-stdout "600"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Secret file successfully secured."
