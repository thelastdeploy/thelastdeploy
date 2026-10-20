#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Inspect Pod Phases
# Module: k8s-pods
# Section: 05-pod-lifecycle
# Lab ID: k8s-watch-pod-lifecycle
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-watch-pod-lifecycle"

# Step 1: Student records lifecycle phase during init container execution
student_exec "mkdir -p \"\$HOME/k8s-pods\" && echo 'Pending' > \"\$HOME/k8s-pods/init-status.txt\"" \
    --desc "Student writes Pending status to target output file" \
    --expect-exit 0

# Step 2: Student verifies file contents
student_exec "cat \"\$HOME/k8s-pods/init-status.txt\"" \
    --desc "Student confirms output file contains Pending" \
    --expect-exit 0 \
    --expect-stdout "Pending"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully verified pod lifecycle pending status!"
