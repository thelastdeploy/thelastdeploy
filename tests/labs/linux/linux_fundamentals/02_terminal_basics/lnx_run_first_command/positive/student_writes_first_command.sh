#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Run your first command
# Module: linux-fundamentals
# Section: 02-terminal-basics
# Lab ID: lnx-run-first-command
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-run-first-command"

# Step 1: Student checks current home contents
student_exec "ls -la ~" \
    --desc "Student lists contents of home directory" \
    --expect-exit 0

# Step 2: Student tests running the echo command directly to stdout
student_exec 'echo "hello devlab"' \
    --desc "Student runs echo to preview command output" \
    --expect-exit 0 \
    --expect-stdout "hello devlab"

# Step 3: Student redirects the echo output into ~/first_command.txt
student_exec 'echo "hello devlab" > ~/first_command.txt' \
    --desc "Student redirects echo output into ~/first_command.txt" \
    --expect-exit 0

# Step 4: Intermediate verification by reading back the file
student_exec "cat ~/first_command.txt" \
    --desc "Student verifies the contents of ~/first_command.txt" \
    --expect-exit 0 \
    --expect-stdout "hello devlab"

# Step 5: Student runs validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: First command run successfully"
