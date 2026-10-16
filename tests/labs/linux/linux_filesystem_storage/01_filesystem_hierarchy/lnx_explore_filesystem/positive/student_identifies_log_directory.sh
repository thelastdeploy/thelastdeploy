#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Explore the filesystem hierarchy
# Module: linux-filesystem-storage
# Section: 01-filesystem-hierarchy
# Lab ID: lnx-explore-filesystem
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-explore-filesystem"

# Step 1: Student inspects the system log directory
student_exec "ls -ld /var/log" \
    --desc "Student inspects /var/log directory" \
    --expect-exit 0

# Step 2: Student saves the absolute path to log_path.txt
student_exec "echo '/var/log' > ~/log_path.txt" \
    --desc "Student writes /var/log to ~/log_path.txt" \
    --expect-exit 0

# Step 3: Student confirms the content of log_path.txt
student_exec "cat ~/log_path.txt" \
    --desc "Student verifies ~/log_path.txt contents" \
    --expect-exit 0 \
    --expect-stdout "/var/log"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Standard log directory path successfully recorded."
