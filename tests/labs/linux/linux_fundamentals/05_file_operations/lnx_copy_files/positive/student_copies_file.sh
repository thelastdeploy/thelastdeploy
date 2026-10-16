#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Copy files in a directory
# Module: linux-fundamentals
# Section: 05-file-operations
# Lab ID: lnx-copy-files
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-copy-files"

# Step 1: Student inspects the source directory
student_exec "ls -la ~/files-test" \
    --desc "Student inspects contents of ~/files-test" \
    --expect-exit 0 \
    --expect-stdout "source.txt"

# Step 2: Student inspects the source file content
student_exec "cat ~/files-test/source.txt" \
    --desc "Student verifies the contents of source.txt" \
    --expect-exit 0 \
    --expect-stdout "copy-me"

# Step 3: Student copies source.txt to destination.txt
student_exec "cp ~/files-test/source.txt ~/files-test/destination.txt" \
    --desc "Student copies source.txt to destination.txt" \
    --expect-exit 0

# Step 4: Intermediate verification by reading back destination.txt
student_exec "cat ~/files-test/destination.txt" \
    --desc "Student verifies content of destination.txt matches source" \
    --expect-exit 0 \
    --expect-stdout "copy-me"

# Step 5: Student confirms original source.txt still exists
student_exec "test -f ~/files-test/source.txt" \
    --desc "Student confirms source.txt was preserved after copy" \
    --expect-exit 0

# Step 6: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: File copied successfully"
