#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Open your first Linux terminal
# Module: linux-fundamentals
# Section: 02-terminal-basics
# Lab ID: lnx-open-terminal
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-open-terminal"

# Step 1: Initial terminal orientation
student_exec "whoami" \
    --desc "Student checks the current logged in user" \
    --expect-exit 0

student_exec "pwd" \
    --desc "Student inspects current working directory" \
    --expect-exit 0

# Step 2: Student inspects the home directory before creating file
student_exec "ls -la ~" \
    --desc "Student lists contents of home directory" \
    --expect-exit 0

# Step 3: Student creates the required terminal_ready file using touch
student_exec "touch ~/terminal_ready" \
    --desc "Student creates empty file 'terminal_ready' in home directory" \
    --expect-exit 0

# Step 4: Intermediate verification step by student
student_exec "ls -l ~/terminal_ready" \
    --desc "Student confirms the file exists in home directory" \
    --expect-exit 0 \
    --expect-stdout "terminal_ready"

# Step 5: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Terminal ready"
