#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Inspect shell builtins vs binary commands
# Module: linux-command-line-tools
# Section: 01-command-discovery
# Lab ID: lnx-inspect-command-options
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-inspect-command-options"

# Step 1: Student inspects the initial cli-test directory
student_exec "ls -la ~/cli-test" \
    --desc "Student inspects ~/cli-test directory" \
    --expect-exit 0

# Step 2: Student uses type to determine how cd is interpreted by the shell
student_exec "type cd" \
    --desc "Student runs type cd to inspect command nature" \
    --expect-exit 0 \
    --expect-stdout "cd is a shell builtin"

# Step 3: Student writes 'builtin' into cd_type.txt
student_exec 'echo "builtin" > ~/cli-test/cd_type.txt' \
    --desc "Student saves 'builtin' into ~/cli-test/cd_type.txt" \
    --expect-exit 0

# Step 4: Intermediate verification by reading back the file
student_exec "cat ~/cli-test/cd_type.txt" \
    --desc "Student verifies the contents of cd_type.txt" \
    --expect-exit 0 \
    --expect-stdout "builtin"

# Step 5: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Shell command type verified successfully."
