#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Find a deeply nested directory path
# Module: linux-fundamentals
# Section: 04-navigation
# Lab ID: lnx-find-target-directory
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-find-target-directory"

# Step 1: Student checks current working directory
student_exec "pwd" \
    --desc "Student inspects initial working directory" \
    --expect-exit 0

# Step 2: Student inspects the search-zone directory
student_exec "ls -la ~/search-zone" \
    --desc "Student checks entry point in ~/search-zone" \
    --expect-exit 0 \
    --expect-stdout "sub1"

# Step 3: Student inspects deeply nested folder chain
student_exec "ls -la ~/search-zone/sub1/sub2/sub3" \
    --desc "Student locates target directory at ~/search-zone/sub1/sub2/sub3" \
    --expect-exit 0 \
    --expect-stdout "target"

# Step 4: Student navigates into the nested target directory and verifies pwd
student_exec "cd ~/search-zone/sub1/sub2/sub3/target && pwd" \
    --desc "Student navigates to deeply nested target and confirms absolute path" \
    --expect-exit 0 \
    --expect-stdout "search-zone/sub1/sub2/sub3/target"

# Step 5: Student saves the absolute path to ~/found_path.txt
student_exec "cd ~/search-zone/sub1/sub2/sub3/target && pwd > ~/found_path.txt" \
    --desc "Student saves target directory path into ~/found_path.txt" \
    --expect-exit 0

# Step 6: Intermediate verification by reading back the file
student_exec "cat ~/found_path.txt" \
    --desc "Student confirms the content of ~/found_path.txt" \
    --expect-exit 0 \
    --expect-stdout "search-zone/sub1/sub2/sub3/target"

# Step 7: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Deeply nested directory found"
