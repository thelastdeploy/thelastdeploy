#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Inspect Environment Variables
# Module: linux-environment-configuration
# Section: 01-environment-variables
# Lab ID: lnx-inspect-environment
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-inspect-environment"

# Step 1: Student inspects environment variables
student_exec "printenv | head -n 5" \
    --desc "Student inspects exported environment variables" \
    --expect-exit 0

# Step 2: Student prints current USER and SHELL variables
student_exec "echo \"User: \$USER, Shell: \$SHELL\"" \
    --desc "Student evaluates USER and SHELL environment variables" \
    --expect-exit 0

# Step 3: Student saves environment summary to target file
student_exec "printf 'USER_NAME=%s\nSHELL_PATH=%s\n' \"\$USER\" \"\$SHELL\" > ~/env-test/env_summary.txt" \
    --desc "Student generates environment summary file" \
    --expect-exit 0

# Step 4: Student verifies contents of env_summary.txt
student_exec "cat ~/env-test/env_summary.txt" \
    --desc "Student views generated summary file" \
    --expect-exit 0 \
    --expect-stdout "USER_NAME="

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Environment inspection summary verified."
