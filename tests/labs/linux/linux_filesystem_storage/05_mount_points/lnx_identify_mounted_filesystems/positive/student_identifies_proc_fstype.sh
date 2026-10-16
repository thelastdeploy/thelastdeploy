#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Identify active mount points and filesystem types
# Module: linux-filesystem-storage
# Section: 05-mount-points
# Lab ID: lnx-identify-mounted-filesystems
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-identify-mounted-filesystems"

# Step 1: Student queries active mount points for /proc
student_exec "findmnt /proc" \
    --desc "Student inspects mount details for /proc" \
    --expect-exit 0 \
    --expect-stdout "proc"

# Step 2: Student extracts the filesystem type and saves to proc_fstype.txt
student_exec "findmnt -no FSTYPE /proc > ~/mount-test/proc_fstype.txt" \
    --desc "Student extracts filesystem type name for /proc" \
    --expect-exit 0

# Step 3: Student verifies recorded filesystem type
student_exec "cat ~/mount-test/proc_fstype.txt" \
    --desc "Student verifies recorded filesystem type" \
    --expect-exit 0 \
    --expect-stdout "proc"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Mount point filesystem type verified successfully."
