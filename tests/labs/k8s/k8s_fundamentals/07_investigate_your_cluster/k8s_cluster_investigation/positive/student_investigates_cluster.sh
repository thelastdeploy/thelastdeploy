#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Investigate Cluster Failures
# Module: k8s-fundamentals
# Section: 07-investigate-your-cluster
# Lab ID: k8s-cluster-investigation
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-cluster-investigation"

# Step 1: Student inspects failing container logs and extracts crash error code
student_exec "mkdir -p \"\$HOME/k8s-fundamentals\" && for i in \$(seq 1 30); do { kubectl logs failing-app 2>/dev/null || kubectl logs failing-app --previous 2>/dev/null; } | grep -o 'ERROR_CODE_[0-9]\+' > \"\$HOME/k8s-fundamentals/crash-code.txt\" && test -s \"\$HOME/k8s-fundamentals/crash-code.txt\" && break || sleep 1; done" \
    --desc "Student extracts crash error code from failing pod logs" \
    --expect-exit 0

# Step 2: Student verifies file content contains target error code
student_exec "cat \"\$HOME/k8s-fundamentals/crash-code.txt\"" \
    --desc "Student confirms extracted error code is ERROR_CODE_7712" \
    --expect-exit 0 \
    --expect-stdout "ERROR_CODE_7712"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully investigated cluster failure and retrieved the crash error code!"
