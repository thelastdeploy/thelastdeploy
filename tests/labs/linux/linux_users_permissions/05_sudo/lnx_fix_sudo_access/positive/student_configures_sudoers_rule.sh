#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure passwordless sudo for a deployer script
# Module: linux-users-permissions
# Section: 05-sudo
# Lab ID: lnx-fix-sudo-access
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-fix-sudo-access"

# Step 1: Student inspects the initial invalid sudo rule
student_exec "cat ~/sudo-test/deployer-sudo" \
    --desc "Student inspects existing deployer-sudo file" \
    --expect-exit 0 \
    --expect-stdout "INVALID_SYNTAX"

# Step 2: Student fixes the rule to grant passwordless sudo for deployer
student_exec "echo 'deployer ALL=(ALL:ALL) NOPASSWD: ALL' > ~/sudo-test/deployer-sudo" \
    --desc "Student writes valid passwordless sudoers entry" \
    --expect-exit 0

# Step 3: Student verifies the updated rule
student_exec "cat ~/sudo-test/deployer-sudo" \
    --desc "Student verifies the updated deployer-sudo content" \
    --expect-exit 0 \
    --expect-stdout "NOPASSWD: ALL"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Passwordless sudo rule successfully configured for deployer."
