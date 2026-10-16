#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Manage Shell Startup Script Cascade
# Module: linux-environment-configuration
# Section: 02-shell-configuration
# Lab ID: lnx-manage-shell-startup
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-manage-shell-startup"

# Step 1: Student checks directory state before creating profile
student_exec "ls -l ~/env-test" \
    --desc "Student inspects env-test directory" \
    --expect-exit 0 \
    --expect-stdout "mock_bashrc"

# Step 2: Student creates mock_profile sourcing mock_bashrc
student_exec "echo 'source \$HOME/env-test/mock_bashrc' > ~/env-test/mock_profile" \
    --desc "Student creates mock_profile with source cascade to mock_bashrc" \
    --expect-exit 0

# Step 3: Student reviews contents of mock_profile
student_exec "cat ~/env-test/mock_profile" \
    --desc "Student confirms mock_profile content" \
    --expect-exit 0 \
    --expect-stdout "source \$HOME/env-test/mock_bashrc"

# Step 4: Student tests sourcing mock_profile
student_exec "bash -c 'source ~/env-test/mock_profile && echo \"SOURCED_SUCCESSFULLY\"'" \
    --desc "Student validates sourcing mock_profile in subshell" \
    --expect-exit 0 \
    --expect-stdout "SOURCED_SUCCESSFULLY"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Shell startup cascade configuration verified."
