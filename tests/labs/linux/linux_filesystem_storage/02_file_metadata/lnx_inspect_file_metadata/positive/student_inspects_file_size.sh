#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Inspect file metadata and size
# Module: linux-filesystem-storage
# Section: 02-file-metadata
# Lab ID: lnx-inspect-file-metadata
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-inspect-file-metadata"

# Step 1: Student runs stat on target_file.txt to inspect metadata
student_exec "stat ~/metadata-test/target_file.txt" \
    --desc "Student inspects file status with stat" \
    --expect-exit 0 \
    --expect-stdout "Size:"

# Step 2: Student extracts exact byte size using stat -c %s
student_exec "stat -c '%s' ~/metadata-test/target_file.txt" \
    --desc "Student extracts byte size using stat format %s" \
    --expect-exit 0 \
    --expect-stdout "40"

# Step 3: Student redirects the size into file_size.txt
student_exec "stat -c '%s' ~/metadata-test/target_file.txt > ~/metadata-test/file_size.txt" \
    --desc "Student saves byte size to ~/metadata-test/file_size.txt" \
    --expect-exit 0

# Step 4: Student confirms the content of file_size.txt
student_exec "cat ~/metadata-test/file_size.txt" \
    --desc "Student verifies file_size.txt content" \
    --expect-exit 0 \
    --expect-stdout "40"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: File metadata byte size verified successfully."
