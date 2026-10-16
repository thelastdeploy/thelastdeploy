#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Check filesystem utilization using df
# Module: linux-filesystem-storage
# Section: 04-disk-usage
# Lab ID: lnx-check-disk-space
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-check-disk-space"

# Step 1: Student checks root filesystem space usage with df
student_exec "df -h /" \
    --desc "Student inspects root filesystem disk space" \
    --expect-exit 0 \
    --expect-stdout "/"

# Step 2: Student saves the root mount point to root_mount.txt
student_exec "echo '/' > ~/disk-test/root_mount.txt" \
    --desc "Student writes root mount point path to root_mount.txt" \
    --expect-exit 0

# Step 3: Student verifies file content
student_exec "cat ~/disk-test/root_mount.txt" \
    --desc "Student verifies recorded mount point" \
    --expect-exit 0 \
    --expect-stdout "/"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Root mount point successfully recorded."
