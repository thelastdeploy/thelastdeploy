#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Explore commands using help flags
# Module: linux-fundamentals
# Section: 08-getting-help
# Lab ID: lnx-help-flags
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-help-flags"

# Step 1: Student checks directory state
student_exec "ls -la ~/help-test" \
    --desc "Student inspects ~/help-test directory" \
    --expect-exit 0

# Step 2: Student uses ls --help to look up the size sorting option
student_exec "ls --help | grep -i 'sort by file size'" \
    --desc "Student finds the file-size sorting option in ls --help" \
    --expect-exit 0 \
    --expect-stdout "-S"

# Step 3: Student writes the -S flag into size_flag.txt
student_exec 'echo "-S" > ~/help-test/size_flag.txt' \
    --desc "Student saves '-S' flag into ~/help-test/size_flag.txt" \
    --expect-exit 0

# Step 4: Intermediate verification by reading back size_flag.txt
student_exec "cat ~/help-test/size_flag.txt" \
    --desc "Student verifies the contents of size_flag.txt" \
    --expect-exit 0 \
    --expect-stdout "-S"

# Step 5: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Size flag found successfully"
