#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: View files using cat
# Module: linux-fundamentals
# Section: 06-viewing-files
# Lab ID: lnx-cat-file
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-cat-file"

# Step 1: Student inspects the view-test directory
student_exec "ls -la ~/view-test" \
    --desc "Student inspects contents of ~/view-test" \
    --expect-exit 0 \
    --expect-stdout "short.txt"

# Step 2: Student uses cat to read the file contents
student_exec "cat ~/view-test/short.txt" \
    --desc "Student prints contents of short.txt using cat" \
    --expect-exit 0 \
    --expect-stdout "LINUX_RULES"

# Step 3: Student writes the extracted code into code.txt
student_exec 'echo "LINUX_RULES" > ~/view-test/code.txt' \
    --desc "Student saves secret code into ~/view-test/code.txt" \
    --expect-exit 0

# Step 4: Intermediate verification by reading back code.txt
student_exec "cat ~/view-test/code.txt" \
    --desc "Student verifies the contents of code.txt" \
    --expect-exit 0 \
    --expect-stdout "LINUX_RULES"

# Step 5: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: File viewed and code extracted"
