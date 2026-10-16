#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Navigate to a nested target folder
# Module: linux-fundamentals
# Section: 04-navigation
# Lab ID: lnx-cd-home
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-cd-home"

# Step 1: Student checks current working directory
student_exec "pwd" \
    --desc "Student inspects initial working directory" \
    --expect-exit 0

# Step 2: Student inspects the navigation-test directory
student_exec "ls -la ~/navigation-test" \
    --desc "Student checks contents of ~/navigation-test" \
    --expect-exit 0 \
    --expect-stdout "target"

# Step 3: Student inspects the nested target directory
student_exec "ls -la ~/navigation-test/target" \
    --desc "Student checks contents of ~/navigation-test/target" \
    --expect-exit 0

# Step 4: Student tests navigating inside the target directory and running pwd
student_exec "cd ~/navigation-test/target && pwd" \
    --desc "Student navigates to target folder and confirms current path" \
    --expect-exit 0 \
    --expect-stdout "navigation-test/target"

# Step 5: Student saves the output of pwd into ~/navigation-test/path.txt
student_exec "cd ~/navigation-test/target && pwd > ~/navigation-test/path.txt" \
    --desc "Student saves current target directory path to ~/navigation-test/path.txt" \
    --expect-exit 0

# Step 6: Intermediate verification by reading back the file
student_exec "cat ~/navigation-test/path.txt" \
    --desc "Student verifies path stored in ~/navigation-test/path.txt" \
    --expect-exit 0 \
    --expect-stdout "navigation-test/target"

# Step 7: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Navigation to target validated"
