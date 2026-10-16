#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Identify a resource-intensive process
# Module: linux-processes-services
# Section: 02-ps-and-top
# Lab ID: lnx-find-memory-hog
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-find-memory-hog"

# Step 1: Student lists processes to find mem_hog_process
student_exec "ps aux | grep mem_hog_process" \
    --desc "Student searches for mem_hog_process using ps and grep" \
    --expect-exit 0 \
    --expect-stdout "mem_hog_process"

# Step 2: Student queries the PID directly using pgrep
student_exec "pgrep -f mem_hog_process" \
    --desc "Student discovers PID with pgrep" \
    --expect-exit 0

# Step 3: Student writes the PID to memory_hog.txt
student_exec "pgrep -f mem_hog_process | head -n 1 > ~/process-test/memory_hog.txt" \
    --desc "Student saves PID to memory_hog.txt" \
    --expect-exit 0

# Step 4: Student verifies file content contains numeric PID
student_exec "cat ~/process-test/memory_hog.txt" \
    --desc "Student checks recorded PID" \
    --expect-exit 0

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Memory hog process successfully identified by PID."
