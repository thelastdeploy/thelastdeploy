#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Understand Effective Permission Evaluation
# Module: linux-security-fundamentals
# Section: 01-linux-security-model
# Lab ID: lnx-understand-effective-permissions
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-understand-effective-permissions"

# Step 1: Student inspects the DAC permission evaluation scenarios
student_exec "cat ~/sec-test/perm_eval.txt" \
    --desc "Student reviews permission evaluation scenarios in perm_eval.txt" \
    --expect-exit 0 \
    --expect-stdout "Scenario 1"

# Step 2: Student writes evaluated results according to DAC evaluation precedence
student_exec "printf 'SCENARIO_1: DENIED\nSCENARIO_2: ALLOWED\nSCENARIO_3: ALLOWED\n' > ~/sec-test/eval_result.txt" \
    --desc "Student writes evaluated outcomes to eval_result.txt" \
    --expect-exit 0

# Step 3: Student confirms contents of eval_result.txt
student_exec "cat ~/sec-test/eval_result.txt" \
    --desc "Student verifies eval_result.txt contents" \
    --expect-exit 0 \
    --expect-stdout "SCENARIO_1: DENIED"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Permission evaluation scenario logic verified."
