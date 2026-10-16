#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Investigate Suspicious Processes and Backdoors
# Module: linux-security-fundamentals
# Section: 05-process-and-user-security
# Lab ID: lnx-investigate-suspicious-process
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-investigate-suspicious-process"

# Step 1: Student inspects process snapshot to audit running processes
student_exec "cat ~/sec-test/proc_snapshot.txt" \
    --desc "Student inspects process snapshot for anomalies" \
    --expect-exit 0 \
    --expect-stdout "4444"

# Step 2: Student isolates suspicious listening process line to suspicious_proc.txt
student_exec "grep -E 'nc|4444' ~/sec-test/proc_snapshot.txt > ~/sec-test/suspicious_proc.txt" \
    --desc "Student extracts backdoor process to destination file" \
    --expect-exit 0

# Step 3: Student verifies recorded suspicious process line
student_exec "cat ~/sec-test/suspicious_proc.txt" \
    --desc "Student verifies recorded suspicious process content" \
    --expect-exit 0 \
    --expect-stdout "2045"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Suspicious process investigation verified."
