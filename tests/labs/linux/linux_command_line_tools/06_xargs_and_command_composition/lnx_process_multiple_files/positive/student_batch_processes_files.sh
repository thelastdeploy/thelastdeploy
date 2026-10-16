#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Batch process multiple files using find and xargs
# Module: linux-command-line-tools
# Section: 06-xargs-and-command-composition
# Lab ID: lnx-process-multiple-files
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-process-multiple-files"

# Step 1: Student inspects the files in the batch directory
student_exec "ls -la ~/xargs-test/batch" \
    --desc "Student inspects the batch directory logs" \
    --expect-exit 0 \
    --expect-stdout "auth.log"

# Step 2: Student tests finding all log files
student_exec "find ~/xargs-test/batch -name '*.log'" \
    --desc "Student locates log files using find" \
    --expect-exit 0 \
    --expect-stdout "sys.log"

# Step 3: Student composes find and grep using xargs to locate FAIL records
student_exec "find ~/xargs-test/batch -name '*.log' | xargs grep 'FAIL'" \
    --desc "Student passes log files into grep via xargs to find FAIL lines" \
    --expect-exit 0 \
    --expect-stdout "FAIL: Storage full"

# Step 4: Student calculates total matching lines using wc -l
student_exec "find ~/xargs-test/batch -name '*.log' | xargs grep 'FAIL' | wc -l" \
    --desc "Student counts total fail lines using wc -l" \
    --expect-exit 0 \
    --expect-stdout "3"

# Step 5: Student redirects the total count into fail_count.txt
student_exec "find ~/xargs-test/batch -name '*.log' | xargs grep 'FAIL' | wc -l > ~/xargs-test/fail_count.txt" \
    --desc "Student saves total fail count to ~/xargs-test/fail_count.txt" \
    --expect-exit 0

# Step 6: Student confirms the content of fail_count.txt
student_exec "cat ~/xargs-test/fail_count.txt" \
    --desc "Student verifies the contents of ~/xargs-test/fail_count.txt" \
    --expect-exit 0 \
    --expect-stdout "3"

# Step 7: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Batch file processing with xargs verified successfully."
