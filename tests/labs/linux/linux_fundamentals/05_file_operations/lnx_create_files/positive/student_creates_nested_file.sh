#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create nested files and directories
# Module: linux-fundamentals
# Section: 05-file-operations
# Lab ID: lnx-create-files
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-create-files"

# Step 1: Student creates the files-test directory using mkdir
student_exec "mkdir -p ~/files-test" \
    --desc "Student creates the ~/files-test directory" \
    --expect-exit 0

# Step 2: Student confirms the directory exists
student_exec "ls -d ~/files-test" \
    --desc "Student verifies ~/files-test directory exists" \
    --expect-exit 0 \
    --expect-stdout "files-test"

# Step 3: Student creates newfile.txt and writes 'created' into it
student_exec 'echo "created" > ~/files-test/newfile.txt' \
    --desc "Student writes 'created' into ~/files-test/newfile.txt" \
    --expect-exit 0

# Step 4: Intermediate verification by reading back the file
student_exec "cat ~/files-test/newfile.txt" \
    --desc "Student confirms the content of newfile.txt is 'created'" \
    --expect-exit 0 \
    --expect-stdout "created"

# Step 5: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Nested file created successfully"
