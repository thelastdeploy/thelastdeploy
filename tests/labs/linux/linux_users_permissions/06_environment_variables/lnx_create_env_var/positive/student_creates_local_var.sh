#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Declare a local shell variable
# Module: linux-users-permissions
# Section: 06-environment-variables
# Lab ID: lnx-create-env-var
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-create-env-var"

# Step 1: Student tests local variable assignment
student_exec "MY_LOCAL_VAR='devlab_local' && echo \$MY_LOCAL_VAR" \
    --desc "Student sets and tests local shell variable" \
    --expect-exit 0 \
    --expect-stdout "devlab_local"

# Step 2: Student saves the assignment syntax into local_var.txt
student_exec "echo 'MY_LOCAL_VAR=devlab_local' > ~/env-test/local_var.txt" \
    --desc "Student saves local variable syntax into ~/env-test/local_var.txt" \
    --expect-exit 0

# Step 3: Student confirms the content of local_var.txt
student_exec "cat ~/env-test/local_var.txt" \
    --desc "Student verifies the saved syntax" \
    --expect-exit 0 \
    --expect-stdout "MY_LOCAL_VAR=devlab_local"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Local shell variable successfully declared."
