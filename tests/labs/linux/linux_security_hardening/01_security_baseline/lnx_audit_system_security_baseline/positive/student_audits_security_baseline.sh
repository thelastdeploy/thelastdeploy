#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Audit System Security Baseline
# Module: linux-security-hardening
# Section: 01-security-baseline
# Lab ID: lnx-audit-system-security-baseline
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-audit-system-security-baseline"

# Step 1: Student creates test working directory
student_exec "mkdir -p ~/sec-test" \
    --desc "Student prepares sec-test directory" \
    --expect-exit 0

# Step 2: Student inspects kernel baseline security parameters
student_exec "sysctl net.ipv4.ip_forward" \
    --desc "Student inspects kernel security parameters" \
    --expect-exit 0

# Step 3: Student generates security baseline report
student_exec "echo 'SECURITY_BASELINE_AUDITED' > ~/sec-test/baseline_report.txt" \
    --desc "Student writes baseline audit report" \
    --expect-exit 0

# Step 4: Student verifies baseline_report.txt content
student_exec "cat ~/sec-test/baseline_report.txt" \
    --desc "Student verifies baseline report content" \
    --expect-exit 0 \
    --expect-stdout "SECURITY_BASELINE_AUDITED"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: System security baseline audit verified."
