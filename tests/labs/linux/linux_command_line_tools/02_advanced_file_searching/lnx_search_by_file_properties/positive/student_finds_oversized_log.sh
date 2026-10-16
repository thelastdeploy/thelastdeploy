#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Search files by size and properties
# Module: linux-command-line-tools
# Section: 02-advanced-file-searching
# Lab ID: lnx-search-by-file-properties
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-search-by-file-properties"

# Step 1: Student inspects the logs folder with human-readable sizes
student_exec "ls -lh ~/search-test/logs" \
    --desc "Student inspects directory file sizes using ls -lh" \
    --expect-exit 0 \
    --expect-stdout "oversized.log"

# Step 2: Student uses find with the -size +5M predicate
student_exec "find \$HOME/search-test/logs -type f -size +5M" \
    --desc "Student locates files larger than 5 Megabytes using find" \
    --expect-exit 0 \
    --expect-stdout "oversized.log"

# Step 3: Student extracts just the filename using basename
student_exec "basename \$(find \$HOME/search-test/logs -type f -size +5M)" \
    --desc "Student isolates the filename 'oversized.log'" \
    --expect-exit 0 \
    --expect-stdout "oversized.log"

# Step 4: Student saves the filename into large_log.txt
student_exec "basename \$(find \$HOME/search-test/logs -type f -size +5M) > ~/search-test/large_log.txt" \
    --desc "Student saves 'oversized.log' into ~/search-test/large_log.txt" \
    --expect-exit 0

# Step 5: Intermediate verification by reading back large_log.txt
student_exec "cat ~/search-test/large_log.txt" \
    --desc "Student confirms the content of large_log.txt" \
    --expect-exit 0 \
    --expect-stdout "oversized.log"

# Step 6: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Large file located successfully."
