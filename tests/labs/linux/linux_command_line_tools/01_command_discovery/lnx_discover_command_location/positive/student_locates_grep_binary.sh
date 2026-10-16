#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Discover executable binary locations
# Module: linux-command-line-tools
# Section: 01-command-discovery
# Lab ID: lnx-discover-command-location
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-discover-command-location"

# Step 1: Student inspects the initial cli-test directory
student_exec "ls -la ~/cli-test" \
    --desc "Student inspects ~/cli-test directory" \
    --expect-exit 0

# Step 2: Student locates the grep binary using which
student_exec "which grep" \
    --desc "Student runs which grep to find the executable path" \
    --expect-exit 0 \
    --expect-stdout-regex "/(usr/)?bin/grep"

# Step 3: Student redirects the output into grep_location.txt
student_exec "which grep > ~/cli-test/grep_location.txt" \
    --desc "Student saves grep binary path into ~/cli-test/grep_location.txt" \
    --expect-exit 0

# Step 4: Intermediate verification by reading back the file
student_exec "cat ~/cli-test/grep_location.txt" \
    --desc "Student verifies contents of grep_location.txt" \
    --expect-exit 0 \
    --expect-stdout-regex "/(usr/)?bin/grep"

# Step 5: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Executable binary location discovered successfully."
