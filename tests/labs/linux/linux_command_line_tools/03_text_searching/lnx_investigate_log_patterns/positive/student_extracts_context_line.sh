#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Investigate log patterns with context matching
# Module: linux-command-line-tools
# Section: 03-text-searching
# Lab ID: lnx-investigate-log-patterns
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-investigate-log-patterns"

# Step 1: Student views the service log file
student_exec "cat ~/grep-test/service.log" \
    --desc "Student inspects ~/grep-test/service.log" \
    --expect-exit 0 \
    --expect-stdout "SIGSEGV"

# Step 2: Student tests context searching using grep -A 1
student_exec "grep -A 1 'SIGSEGV' ~/grep-test/service.log" \
    --desc "Student searches for SIGSEGV with 1 trailing line of context" \
    --expect-exit 0 \
    --expect-stdout "Core dump written to /var/dumps/core.9902"

# Step 3: Student extracts the single trailing line using tail -n 1
student_exec "grep -A 1 'SIGSEGV' ~/grep-test/service.log | tail -n 1" \
    --desc "Student isolates the context line following SIGSEGV" \
    --expect-exit 0 \
    --expect-stdout "Core dump written to /var/dumps/core.9902"

# Step 4: Student writes the line to next_line.txt
student_exec "grep -A 1 'SIGSEGV' ~/grep-test/service.log | tail -n 1 > ~/grep-test/next_line.txt" \
    --desc "Student saves the context line into next_line.txt" \
    --expect-exit 0

# Step 5: Student confirms content of next_line.txt
student_exec "cat ~/grep-test/next_line.txt" \
    --desc "Student verifies the contents of next_line.txt" \
    --expect-exit 0 \
    --expect-stdout "Core dump written to /var/dumps/core.9902"

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Context line after SIGSEGV extracted successfully."
