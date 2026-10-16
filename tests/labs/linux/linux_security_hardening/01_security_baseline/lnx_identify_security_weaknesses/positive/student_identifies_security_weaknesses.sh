#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Identify System Security Weaknesses
# Module: linux-security-hardening
# Section: 01-security-baseline
# Lab ID: lnx-identify-security-weaknesses
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-identify-security-weaknesses"

# Step 1: Student creates test working directory
student_exec "mkdir -p ~/sec-test" \
    --desc "Student prepares sec-test directory" \
    --expect-exit 0

# Step 2: Student inspects network listeners for potential exposure
student_exec "ss -tulpn || true" \
    --desc "Student audits open network sockets" \
    --expect-exit 0

# Step 3: Student writes identified security weaknesses report
student_exec "echo 'WEAKNESSES_IDENTIFIED' > ~/sec-test/weaknesses.txt" \
    --desc "Student writes security weaknesses report" \
    --expect-exit 0

# Step 4: Student verifies weaknesses.txt content
student_exec "cat ~/sec-test/weaknesses.txt" \
    --desc "Student verifies recorded weaknesses content" \
    --expect-exit 0 \
    --expect-stdout "WEAKNESSES_IDENTIFIED"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: System security weaknesses identification verified."
