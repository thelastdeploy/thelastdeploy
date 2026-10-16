#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Diagnose Configuration Problems
# Module: linux-environment-configuration
# Section: 05-configuration-troubleshooting
# Lab ID: lnx-diagnose-configuration-problem
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-diagnose-configuration-problem"

# Step 1: Student inspects the error log
student_exec "cat ~/env-test/app_error.log" \
    --desc "Student examines application error log" \
    --expect-exit 0 \
    --expect-stdout "integer expected"

# Step 2: Student inspects the broken configuration file
student_exec "cat ~/env-test/broken_app.conf" \
    --desc "Student inspects broken configuration parameter values" \
    --expect-exit 0 \
    --expect-stdout "PORT=INVALID_PORT_STRING"

# Step 3: Student records root cause in diagnosis.txt
student_exec "echo 'ROOT_CAUSE: INVALID_PORT' > ~/env-test/diagnosis.txt" \
    --desc "Student writes diagnostic finding to diagnosis.txt" \
    --expect-exit 0

# Step 4: Student verifies contents of diagnosis.txt
student_exec "cat ~/env-test/diagnosis.txt" \
    --desc "Student verifies diagnosis report" \
    --expect-exit 0 \
    --expect-stdout "ROOT_CAUSE: INVALID_PORT"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Configuration diagnosis report verified."
