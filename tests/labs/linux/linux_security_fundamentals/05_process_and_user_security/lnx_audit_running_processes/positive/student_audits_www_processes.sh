#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Audit Process User Ownership
# Module: linux-security-fundamentals
# Section: 05-process-and-user-security
# Lab ID: lnx-audit-running-processes
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-audit-running-processes"

# Step 1: Student inspects process dump to review running processes and users
student_exec "cat ~/sec-test/ps_dump.txt" \
    --desc "Student inspects daemon process dump" \
    --expect-exit 0 \
    --expect-stdout "www-data"

# Step 2: Student filters processes owned by www-data into www_processes.txt
student_exec "grep 'www-data' ~/sec-test/ps_dump.txt > ~/sec-test/www_processes.txt" \
    --desc "Student filters www-data processes to destination file" \
    --expect-exit 0

# Step 3: Student verifies recorded www-data process lines
student_exec "cat ~/sec-test/www_processes.txt" \
    --desc "Student verifies recorded www-data processes" \
    --expect-exit 0 \
    --expect-stdout "nginx"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Process ownership audit verified."
