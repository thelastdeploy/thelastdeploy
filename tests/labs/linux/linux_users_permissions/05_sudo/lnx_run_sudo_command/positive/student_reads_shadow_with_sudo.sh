#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: View protected credentials using sudo
# Module: linux-users-permissions
# Section: 05-sudo
# Lab ID: lnx-run-sudo-command
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-run-sudo-command"

# Step 1: Student runs sudo head -n 1 /etc/shadow to read root credential record
student_exec "sudo head -n 1 /etc/shadow" \
    --desc "Student uses sudo to read first line of /etc/shadow" \
    --expect-exit 0 \
    --expect-stdout "root:"

# Step 2: Student redirects the first line into admin_only.txt
student_exec "sudo head -n 1 /etc/shadow > ~/sudo-test/admin_only.txt" \
    --desc "Student saves root entry to ~/sudo-test/admin_only.txt" \
    --expect-exit 0

# Step 3: Student verifies the file content
student_exec "cat ~/sudo-test/admin_only.txt" \
    --desc "Student confirms root shadow record was written" \
    --expect-exit 0 \
    --expect-stdout "root:"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully retrieved protected system credentials using sudo."
