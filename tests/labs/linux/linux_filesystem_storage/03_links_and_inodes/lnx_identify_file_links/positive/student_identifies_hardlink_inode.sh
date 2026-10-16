#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Identify hard-linked files using inode numbers
# Module: linux-filesystem-storage
# Section: 03-links-and-inodes
# Lab ID: lnx-identify-file-links
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-identify-file-links"

# Step 1: Student inspects the check_zone files with their inode numbers
student_exec "ls -li ~/link-test/check_zone" \
    --desc "Student lists check_zone files with inode numbers via ls -li" \
    --expect-exit 0 \
    --expect-stdout "original.txt"

# Step 2: Student finds the file sharing the same inode as original.txt
student_exec "find ~/link-test/check_zone -samefile ~/link-test/check_zone/original.txt ! -name 'original.txt'" \
    --desc "Student locates hard link using find -samefile" \
    --expect-exit 0 \
    --expect-stdout "file_b.txt"

# Step 3: Student extracts just the filename using basename
student_exec "basename \$(find ~/link-test/check_zone -samefile ~/link-test/check_zone/original.txt ! -name 'original.txt')" \
    --desc "Student extracts filename file_b.txt" \
    --expect-exit 0 \
    --expect-stdout "file_b.txt"

# Step 4: Student saves the filename to same_inode.txt
student_exec "basename \$(find ~/link-test/check_zone -samefile ~/link-test/check_zone/original.txt ! -name 'original.txt') > ~/link-test/same_inode.txt" \
    --desc "Student writes file_b.txt to ~/link-test/same_inode.txt" \
    --expect-exit 0

# Step 5: Student confirms the content of same_inode.txt
student_exec "cat ~/link-test/same_inode.txt" \
    --desc "Student verifies saved filename" \
    --expect-exit 0 \
    --expect-stdout "file_b.txt"

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Hard-linked inode file identified successfully."
