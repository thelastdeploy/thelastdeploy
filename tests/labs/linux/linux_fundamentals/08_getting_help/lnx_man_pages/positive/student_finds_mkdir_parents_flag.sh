#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Look up options in man pages
# Module: linux-fundamentals
# Section: 08-getting-help
# Lab ID: lnx-man-pages
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-man-pages"

# Step 1: Student checks directory state
student_exec "ls -la ~/help-test" \
    --desc "Student inspects ~/help-test directory" \
    --expect-exit 0

# Step 2: Student looks up mkdir manual/help to find the parents option
student_exec "mkdir --help | grep -i 'parents'" \
    --desc "Student discovers the -p / --parents flag for mkdir" \
    --expect-exit 0 \
    --expect-stdout "-p"

# Step 3: Student writes the flag into parents_flag.txt
student_exec 'echo "-p" > ~/help-test/parents_flag.txt' \
    --desc "Student saves '-p' flag into ~/help-test/parents_flag.txt" \
    --expect-exit 0

# Step 4: Intermediate verification by reading back parents_flag.txt
student_exec "cat ~/help-test/parents_flag.txt" \
    --desc "Student verifies the contents of parents_flag.txt" \
    --expect-exit 0 \
    --expect-stdout "-p"

# Step 5: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Parents flag found successfully"
