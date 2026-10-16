#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Remove a system user
# Module: linux-users-permissions
# Section: 07-user-management
# Lab ID: lnx-remove-user
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-remove-user"

# Step 1: Student confirms the user exists before deletion
student_exec "id dev-intern" \
    --desc "Student confirms dev-intern exists initially" \
    --expect-exit 0 \
    --expect-stdout "dev-intern"

# Step 2: Student removes the user account using sudo userdel
student_exec "sudo userdel dev-intern" \
    --desc "Student deletes user dev-intern with userdel" \
    --expect-exit 0

# Step 3: Student confirms user was removed from system
student_exec "id dev-intern || echo 'User removed successfully'" \
    --desc "Student checks that user lookup fails after removal" \
    --expect-exit 0 \
    --expect-stdout "User removed successfully"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: User 'dev-intern' successfully removed from the system."
