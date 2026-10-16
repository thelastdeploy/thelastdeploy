#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Identify standard system directories
# Module: linux-fundamentals
# Section: 03-filesystem-overview
# Lab ID: lnx-identify-directories
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-identify-directories"

# Step 1: Student explores the root filesystem to inspect directory layout
student_exec "ls /" \
    --desc "Student explores root directory to identify standard system folders" \
    --expect-exit 0 \
    --expect-stdout "etc"

# Step 2: Student inspects the system configuration directory
student_exec "ls -d /etc" \
    --desc "Student verifies the system configurations directory path" \
    --expect-exit 0 \
    --expect-stdout "/etc"

# Step 3: Student writes the absolute path of /etc into ~/directories.txt
student_exec 'echo "/etc" > ~/directories.txt' \
    --desc "Student writes '/etc' into ~/directories.txt" \
    --expect-exit 0

# Step 4: Intermediate verification by reading back the file
student_exec "cat ~/directories.txt" \
    --desc "Student confirms file contents match '/etc'" \
    --expect-exit 0 \
    --expect-stdout "/etc"

# Step 5: Student runs validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Configuration directory identified"
