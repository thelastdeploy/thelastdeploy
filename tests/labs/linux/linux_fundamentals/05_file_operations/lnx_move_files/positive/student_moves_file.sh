#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Move or rename files
# Module: linux-fundamentals
# Section: 05-file-operations
# Lab ID: lnx-move-files
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-move-files"

# Step 1: Student inspects the initial file to rename/move
student_exec "ls -la ~/files-test/move-me.txt" \
    --desc "Student confirms move-me.txt exists prior to moving" \
    --expect-exit 0 \
    --expect-stdout "move-me.txt"

# Step 2: Student reads the content of the file
student_exec "cat ~/files-test/move-me.txt" \
    --desc "Student inspects content of move-me.txt" \
    --expect-exit 0 \
    --expect-stdout "moved"

# Step 3: Student renames the file using mv
student_exec "mv ~/files-test/move-me.txt ~/files-test/moved.txt" \
    --desc "Student moves/renames move-me.txt to moved.txt" \
    --expect-exit 0

# Step 4: Intermediate verification that the old filename is gone
student_exec "test ! -f ~/files-test/move-me.txt" \
    --desc "Student confirms old file move-me.txt is gone" \
    --expect-exit 0

# Step 5: Intermediate verification that the new file exists with preserved content
student_exec "cat ~/files-test/moved.txt" \
    --desc "Student confirms moved.txt exists with preserved content" \
    --expect-exit 0 \
    --expect-stdout "moved"

# Step 6: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: File moved and renamed successfully"
