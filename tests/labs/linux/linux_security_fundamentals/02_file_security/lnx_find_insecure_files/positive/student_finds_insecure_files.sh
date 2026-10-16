#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Find Insecure World-Writable Files
# Module: linux-security-fundamentals
# Section: 02-file-security
# Lab ID: lnx-find-insecure-files
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-find-insecure-files"

# Step 1: Student discovers world-writable files using find -perm -0002
student_exec "find ~/sec-test/audit_dir -type f -perm -0002" \
    --desc "Student searches audit_dir for world-writable files" \
    --expect-exit 0 \
    --expect-stdout "secret.key"

# Step 2: Student outputs findings to insecure_files.txt
student_exec "find ~/sec-test/audit_dir -type f -perm -0002 > ~/sec-test/insecure_files.txt" \
    --desc "Student saves discovered world-writable files to insecure_files.txt" \
    --expect-exit 0

# Step 3: Student confirms insecure_files.txt content
student_exec "cat ~/sec-test/insecure_files.txt" \
    --desc "Student verifies insecure file audit list" \
    --expect-exit 0 \
    --expect-stdout "secret.key"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: World-writable file search verified."
