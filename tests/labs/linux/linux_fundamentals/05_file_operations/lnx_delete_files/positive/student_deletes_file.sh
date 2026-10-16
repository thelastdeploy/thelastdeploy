#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Delete files using rm
# Module: linux-fundamentals
# Section: 05-file-operations
# Lab ID: lnx-delete-files
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-delete-files"

# Step 1: Student inspects the file that needs to be deleted
student_exec "ls -la ~/files-test/delete-me.txt" \
    --desc "Student confirms delete-me.txt exists prior to deletion" \
    --expect-exit 0 \
    --expect-stdout "delete-me.txt"

# Step 2: Student inspects the file content
student_exec "cat ~/files-test/delete-me.txt" \
    --desc "Student checks contents of delete-me.txt" \
    --expect-exit 0 \
    --expect-stdout "delete-me"

# Step 3: Student deletes the file using rm
student_exec "rm ~/files-test/delete-me.txt" \
    --desc "Student removes the file using rm" \
    --expect-exit 0

# Step 4: Intermediate verification that the file no longer exists
student_exec "test ! -f ~/files-test/delete-me.txt" \
    --desc "Student confirms delete-me.txt has been permanently removed" \
    --expect-exit 0

# Step 5: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: File deleted successfully"
