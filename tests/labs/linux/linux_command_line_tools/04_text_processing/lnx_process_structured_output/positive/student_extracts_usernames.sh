#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Process structured CSV output using field delimiters
# Module: linux-command-line-tools
# Section: 04-text-processing
# Lab ID: lnx-process-structured-output
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-process-structured-output"

# Step 1: Student inspects the CSV file contents
student_exec "cat ~/text-test/users.csv" \
    --desc "Student inspects raw user CSV data" \
    --expect-exit 0 \
    --expect-stdout "1,alice,admin"

# Step 2: Student tests field extraction of usernames with cut
student_exec "cut -d',' -f2 ~/text-test/users.csv" \
    --desc "Student tests field 2 extraction using cut with comma delimiter" \
    --expect-exit 0 \
    --expect-stdout "alice"

# Step 3: Student redirects the extracted usernames into usernames.txt
student_exec "cut -d',' -f2 ~/text-test/users.csv > ~/text-test/usernames.txt" \
    --desc "Student saves extracted usernames into ~/text-test/usernames.txt" \
    --expect-exit 0

# Step 4: Student confirms file contents
student_exec "cat ~/text-test/usernames.txt" \
    --desc "Student verifies saved usernames file" \
    --expect-exit 0 \
    --expect-stdout "charlie"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Structured CSV output processed successfully."
