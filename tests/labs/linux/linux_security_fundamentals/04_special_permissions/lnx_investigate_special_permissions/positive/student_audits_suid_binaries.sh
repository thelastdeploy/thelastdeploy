#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Investigate Special SUID/SGID/Sticky Bit Permissions
# Module: linux-security-fundamentals
# Section: 04-special-permissions
# Lab ID: lnx-investigate-special-permissions
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-investigate-special-permissions"

# Step 1: Student inspects the bin_audit directory to discover files and permissions
student_exec "ls -la ~/sec-test/bin_audit" \
    --desc "Student inspects special permission test directory" \
    --expect-exit 0 \
    --expect-stdout "suid_tool"

# Step 2: Student searches for SUID binaries and saves paths to suid_files.txt
student_exec "find \$HOME/sec-test -type f -perm -4000 > ~/sec-test/suid_files.txt" \
    --desc "Student locates SUID binaries and writes to suid_files.txt" \
    --expect-exit 0

# Step 3: Student verifies recorded SUID binaries list
student_exec "cat ~/sec-test/suid_files.txt" \
    --desc "Student verifies recorded SUID files" \
    --expect-exit 0 \
    --expect-stdout "suid_tool"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: SUID special permission audit verified."
