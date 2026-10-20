#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: List Deployments
# Module: k8s-workloads
# Section: 02-deployments
# Lab ID: k8s-list-deployments
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-list-deployments"

# Step 1: Student queries deployments across all namespaces and counts them
student_exec "mkdir -p \"\$HOME/k8s-workloads\" && kubectl get deployments -A --no-headers | wc -l | tr -d ' ' > \"\$HOME/k8s-workloads/deployments-count.txt\"" \
    --desc "Student writes cluster-wide deployment count to output file" \
    --expect-exit 0

# Step 2: Student verifies output file is non-empty integer
student_exec "[[ \$(cat \"\$HOME/k8s-workloads/deployments-count.txt\") =~ ^[0-9]+$ ]]" \
    --desc "Student confirms output file contains valid integer" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Deployments count successfully verified!"
