#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Investigate Permissive Sudoers Rules
# Module: linux-security-fundamentals
# Section: 03-sudo-and-privilege
# Lab ID: lnx-investigate-privilege-access
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-investigate-privilege-access"

# Step 1: Student inspects mock_sudoers definitions
student_exec "cat ~/sec-test/mock_sudoers" \
    --desc "Student inspects sudoers privileges in mock_sudoers" \
    --expect-exit 0 \
    --expect-stdout "NOPASSWD: ALL"

# Step 2: Student isolates account with NOPASSWD: ALL rule
student_exec "grep 'NOPASSWD: ALL' ~/sec-test/mock_sudoers | awk '{print \$1}' > ~/sec-test/permissive_user.txt" \
    --desc "Student extracts permissive account name to permissive_user.txt" \
    --expect-exit 0

# Step 3: Student verifies contents of permissive_user.txt
student_exec "cat ~/sec-test/permissive_user.txt" \
    --desc "Student confirms extracted username" \
    --expect-exit 0 \
    --expect-stdout "deploy_user"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Permissive sudoers rule investigation verified."
