#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Record your running processes
# Module: linux-processes-services
# Section: 02-ps-and-top
# Lab ID: lnx-list-running-processes
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-list-running-processes"

# Step 1: Student creates process-test directory if not present
student_exec "mkdir -p ~/process-test" \
    --desc "Student ensures target directory exists" \
    --expect-exit 0

# Step 2: Student inspects running processes using ps
student_exec "ps aux | head -n 10" \
    --desc "Student inspects active process listing" \
    --expect-exit 0 \
    --expect-stdout "PID"

# Step 3: Student redirects the process list to my_processes.txt
student_exec "ps aux > ~/process-test/my_processes.txt" \
    --desc "Student saves process list to my_processes.txt" \
    --expect-exit 0

# Step 4: Student verifies that the file contains process records
student_exec "head -n 5 ~/process-test/my_processes.txt" \
    --desc "Student verifies recorded process entries" \
    --expect-exit 0 \
    --expect-stdout "PID"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Process list recorded successfully."
