#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Investigate unstructured messy log dumps
# Module: linux-command-line-tools
# Section: 08-cli-investigation
# Lab ID: lnx-investigate-messy-log
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-investigate-messy-log"

# Step 1: Student views the raw dump log file
student_exec "cat ~/cli-investigation/raw_dump.log" \
    --desc "Student inspects unstructured log records in raw_dump.log" \
    --expect-exit 0 \
    --expect-stdout "AUTH_FAILURE"

# Step 2: Student filters the dump for AUTH_FAILURE records
student_exec "grep 'AUTH_FAILURE' ~/cli-investigation/raw_dump.log" \
    --desc "Student filters lines matching AUTH_FAILURE" \
    --expect-exit 0 \
    --expect-stdout "user=user_88"

# Step 3: Student extracts the user value by isolating column 3 and cutting the key
student_exec "grep 'AUTH_FAILURE' ~/cli-investigation/raw_dump.log | awk '{print \$3}' | cut -d'=' -f2" \
    --desc "Student extracts user IDs using awk and cut" \
    --expect-exit 0 \
    --expect-stdout "user_88"

# Step 4: Student aggregates failure count per user ID in descending order
student_exec "grep 'AUTH_FAILURE' ~/cli-investigation/raw_dump.log | awk '{print \$3}' | cut -d'=' -f2 | sort | uniq -c | sort -nr" \
    --desc "Student counts and ranks failure counts per user" \
    --expect-exit 0 \
    --expect-stdout "3 user_88"

# Step 5: Student isolates the top failed user ID
student_exec "grep 'AUTH_FAILURE' ~/cli-investigation/raw_dump.log | awk '{print \$3}' | cut -d'=' -f2 | sort | uniq -c | sort -nr | head -n 1 | awk '{print \$2}'" \
    --desc "Student isolates the top offender user ID" \
    --expect-exit 0 \
    --expect-stdout "user_88"

# Step 6: Student saves the user ID into bad_user.txt
student_exec "grep 'AUTH_FAILURE' ~/cli-investigation/raw_dump.log | awk '{print \$3}' | cut -d'=' -f2 | sort | uniq -c | sort -nr | head -n 1 | awk '{print \$2}' > ~/cli-investigation/bad_user.txt" \
    --desc "Student saves identified user ID to ~/cli-investigation/bad_user.txt" \
    --expect-exit 0

# Step 7: Student verifies file content
student_exec "cat ~/cli-investigation/bad_user.txt" \
    --desc "Student verifies the contents of ~/cli-investigation/bad_user.txt" \
    --expect-exit 0 \
    --expect-stdout "user_88"

# Step 8: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Bad user ID identified correctly from messy log dump."
