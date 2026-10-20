#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Debug CrashLoopBackOff
# Module: k8s-troubleshooting
# Section: 02-debugging-pods
# Lab ID: k8s-debug-crashloopbackoff
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-debug-crashloopbackoff"

# Step 1: Student extracts crash code from pod logs and writes to file
student_exec "kubectl logs crashing-app > ~/k8s-troubleshooting/crash-code.txt || true" \
    --desc "Student saves crashing-app logs to file" \
    --expect-exit 0

# Step 2: Student verifies crash code file
student_exec "cat ~/k8s-troubleshooting/crash-code.txt" \
    --desc "Student inspects crash-code.txt" \
    --expect-exit 0 \
    --expect-stdout "FATAL_ERROR_CODE_9876"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully identified the crashed error code from pod logs!"
