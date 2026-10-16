#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create a new system user
# Module: linux-users-permissions
# Section: 07-user-management
# Lab ID: lnx-create-user
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-create-user"

# Step 1: Student creates the user dev-intern using sudo useradd
student_exec "sudo useradd dev-intern" \
    --desc "Student creates user dev-intern with useradd" \
    --expect-exit 0

# Step 2: Student verifies the user exists on the system
student_exec "id dev-intern" \
    --desc "Student confirms user dev-intern exists using id" \
    --expect-exit 0 \
    --expect-stdout "dev-intern"

# Step 3: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: User 'dev-intern' successfully created."
