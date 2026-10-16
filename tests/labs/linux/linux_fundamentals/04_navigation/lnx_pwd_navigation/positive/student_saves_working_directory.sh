#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Save your working directory path
# Module: linux-fundamentals
# Section: 04-navigation
# Lab ID: lnx-pwd-navigation
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-pwd-navigation"

# Step 1: Student checks initial working directory
student_exec "pwd" \
    --desc "Student inspects initial working directory" \
    --expect-exit 0

# Step 2: Student navigates to home directory using cd ~ and verifies pwd
student_exec "cd ~ && pwd" \
    --desc "Student navigates to home directory and confirms path" \
    --expect-exit 0 \
    --expect-stdout-regex "/(root|home/ubuntu)"

# Step 3: Student redirects pwd output into ~/current_path.txt
student_exec "cd ~ && pwd > ~/current_path.txt" \
    --desc "Student saves home directory path into ~/current_path.txt" \
    --expect-exit 0

# Step 4: Intermediate verification by reading back the file
student_exec "cat ~/current_path.txt" \
    --desc "Student confirms content of ~/current_path.txt matches home path" \
    --expect-exit 0 \
    --expect-stdout-regex "/(root|home/ubuntu)"

# Step 5: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Working directory saved successfully"
