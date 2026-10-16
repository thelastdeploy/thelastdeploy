#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Export an environment variable
# Module: linux-users-permissions
# Section: 06-environment-variables
# Lab ID: lnx-export-variable
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-export-variable"

# Step 1: Student tests exporting the variable and querying it
student_exec "export DEVLAB_MODE='production' && printenv DEVLAB_MODE" \
    --desc "Student exports and prints environment variable" \
    --expect-exit 0 \
    --expect-stdout "production"

# Step 2: Student saves the export command into export_cmd.txt
student_exec "echo 'export DEVLAB_MODE=production' > ~/env-test/export_cmd.txt" \
    --desc "Student writes export command to ~/env-test/export_cmd.txt" \
    --expect-exit 0

# Step 3: Student confirms the content of export_cmd.txt
student_exec "cat ~/env-test/export_cmd.txt" \
    --desc "Student verifies the saved export command" \
    --expect-exit 0 \
    --expect-stdout "export DEVLAB_MODE=production"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Environment variable export syntax verified."
