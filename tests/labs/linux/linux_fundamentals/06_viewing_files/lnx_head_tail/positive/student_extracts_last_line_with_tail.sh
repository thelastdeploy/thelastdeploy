#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Inspect files with head and tail
# Module: linux-fundamentals
# Section: 06-viewing-files
# Lab ID: lnx-head-tail
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-head-tail"

# Step 1: Student inspects the view-test directory
student_exec "ls -la ~/view-test" \
    --desc "Student inspects contents of ~/view-test" \
    --expect-exit 0 \
    --expect-stdout "growth.txt"

# Step 2: Student previews the beginning of the file using head
student_exec "head -n 3 ~/view-test/growth.txt" \
    --desc "Student previews first 3 lines using head" \
    --expect-exit 0 \
    --expect-stdout "first_line"

# Step 3: Student previews the end of the file using tail
student_exec "tail -n 3 ~/view-test/growth.txt" \
    --desc "Student previews last 3 lines using tail" \
    --expect-exit 0 \
    --expect-stdout "last_line"

# Step 4: Student extracts exactly the last line with tail -n 1
student_exec "tail -n 1 ~/view-test/growth.txt" \
    --desc "Student extracts only the last line" \
    --expect-exit 0 \
    --expect-stdout "last_line"

# Step 5: Student redirects the last line to ~/view-test/end.txt
student_exec "tail -n 1 ~/view-test/growth.txt > ~/view-test/end.txt" \
    --desc "Student saves last line to ~/view-test/end.txt" \
    --expect-exit 0

# Step 6: Intermediate verification by reading back end.txt
student_exec "cat ~/view-test/end.txt" \
    --desc "Student verifies the contents of end.txt" \
    --expect-exit 0 \
    --expect-stdout "last_line"

# Step 7: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Last line extracted successfully"
