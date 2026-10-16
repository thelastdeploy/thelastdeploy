#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create a symbolic link to a configuration file
# Module: linux-filesystem-storage
# Section: 03-links-and-inodes
# Lab ID: lnx-create-symbolic-link
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-create-symbolic-link"

# Step 1: Student inspects the target configuration file
student_exec "ls -l ~/link-test/configs/app_v2.conf" \
    --desc "Student inspects the target configuration file" \
    --expect-exit 0

# Step 2: Student creates a symbolic link using ln -s
student_exec "ln -s ~/link-test/configs/app_v2.conf ~/link-test/current_config.conf" \
    --desc "Student creates symbolic link pointing to app_v2.conf" \
    --expect-exit 0

# Step 3: Student verifies the symlink points to the target
student_exec "readlink -f ~/link-test/current_config.conf" \
    --desc "Student resolves symlink path with readlink -f" \
    --expect-exit 0 \
    --expect-stdout "app_v2.conf"

# Step 4: Student reads the file content through the symlink
student_exec "cat ~/link-test/current_config.conf" \
    --desc "Student verifies target file content via symlink" \
    --expect-exit 0 \
    --expect-stdout "PORT=8080"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Symbolic link successfully verified."
