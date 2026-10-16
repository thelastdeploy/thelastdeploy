#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Investigate hidden large files consuming storage
# Module: linux-filesystem-storage
# Section: 06-filesystem-investigation
# Lab ID: lnx-investigate-storage-usage
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-investigate-storage-usage"

# Step 1: Student lists all files including hidden files in sub_logs
student_exec "ls -la ~/storage-investigation/sub_logs" \
    --desc "Student inspects subfolder including hidden dotfiles" \
    --expect-exit 0 \
    --expect-stdout ".hidden_dump.log"

# Step 2: Student searches for large hidden files using find
student_exec "find ~/storage-investigation -name '.*' -size +1M" \
    --desc "Student locates hidden files larger than 1M" \
    --expect-exit 0 \
    --expect-stdout ".hidden_dump.log"

# Step 3: Student extracts the culprit file name and saves it to culprit.txt
student_exec "basename \$(find ~/storage-investigation -name '.*' -size +1M) > ~/storage-investigation/culprit.txt" \
    --desc "Student writes culprit filename to culprit.txt" \
    --expect-exit 0

# Step 4: Student verifies recorded culprit filename
student_exec "cat ~/storage-investigation/culprit.txt" \
    --desc "Student verifies recorded filename" \
    --expect-exit 0 \
    --expect-stdout ".hidden_dump.log"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Culprit storage file identified successfully."
