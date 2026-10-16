#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Search secret line using grep
# Module: linux-fundamentals
# Section: 07-file-searching
# Lab ID: lnx-grep-secret
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-grep-secret"

# Step 1: Student uses grep -r to find the key across configs
student_exec "grep -r 'devlab-key' ~/search-test/configs" \
    --desc "Student recursively searches configs for 'devlab-key'" \
    --expect-exit 0 \
    --expect-stdout "app_secret=devlab-key"

# Step 2: Student isolates the matching line without filename prefix (-h)
student_exec "grep -rh 'devlab-key' ~/search-test/configs" \
    --desc "Student uses grep -rh to output only the matching line" \
    --expect-exit 0 \
    --expect-stdout "app_secret=devlab-key"

# Step 3: Student redirects the isolated secret line to secret_line.txt
student_exec "grep -rh 'devlab-key' ~/search-test/configs > ~/search-test/secret_line.txt" \
    --desc "Student saves secret line into ~/search-test/secret_line.txt" \
    --expect-exit 0

# Step 4: Intermediate verification by reading back secret_line.txt
student_exec "cat ~/search-test/secret_line.txt" \
    --desc "Student verifies the contents of secret_line.txt" \
    --expect-exit 0 \
    --expect-stdout "app_secret=devlab-key"

# Step 5: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Secret line grepped successfully"
