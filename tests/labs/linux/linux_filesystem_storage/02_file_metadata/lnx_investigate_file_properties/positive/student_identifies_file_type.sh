#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Investigate unknown file properties and types
# Module: linux-filesystem-storage
# Section: 02-file-metadata
# Lab ID: lnx-investigate-file-properties
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-investigate-file-properties"

# Step 1: Student uses file command to determine the format of unknown_file
student_exec "file ~/metadata-test/unknown_file" \
    --desc "Student inspects unknown_file format with file utility" \
    --expect-exit 0 \
    --expect-stdout "gzip compressed data"

# Step 2: Student saves the identified format type into file_type.txt
student_exec "echo 'gzip' > ~/metadata-test/file_type.txt" \
    --desc "Student writes gzip to ~/metadata-test/file_type.txt" \
    --expect-exit 0

# Step 3: Student confirms the content of file_type.txt
student_exec "cat ~/metadata-test/file_type.txt" \
    --desc "Student verifies file_type.txt content" \
    --expect-exit 0 \
    --expect-stdout "gzip"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: File format type identified successfully."
