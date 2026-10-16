#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Locate space-consuming files in log directories
# Module: linux-filesystem-storage
# Section: 04-disk-usage
# Lab ID: lnx-find-large-files
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-find-large-files"

# Step 1: Student inspects the logs directory
student_exec "ls -lh ~/disk-test/logs" \
    --desc "Student lists log files with human-readable sizes" \
    --expect-exit 0 \
    --expect-stdout "heavy_dump.log"

# Step 2: Student identifies directory disk usage breakdown
student_exec "du -sh ~/disk-test/logs/*" \
    --desc "Student inspects size of individual log files" \
    --expect-exit 0 \
    --expect-stdout "25M"

# Step 3: Student locates the largest file using sort by size
student_exec "ls -lSh ~/disk-test/logs | head -n 2 | tail -n 1 | awk '{print \$NF}' > ~/disk-test/largest_file.txt" \
    --desc "Student extracts filename of the largest log file" \
    --expect-exit 0

# Step 4: Student checks recorded filename in largest_file.txt
student_exec "cat ~/disk-test/largest_file.txt" \
    --desc "Student verifies recorded filename" \
    --expect-exit 0 \
    --expect-stdout "heavy_dump.log"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Space-consuming file identified successfully."
