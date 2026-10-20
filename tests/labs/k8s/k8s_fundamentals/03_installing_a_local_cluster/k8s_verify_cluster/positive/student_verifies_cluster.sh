#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Verify Cluster Access
# Module: k8s-fundamentals
# Section: 03-installing-a-local-cluster
# Lab ID: k8s-verify-cluster
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-verify-cluster"

# Step 1: Student extracts node name using kubectl jsonpath
student_exec "mkdir -p \"\$HOME/k8s-fundamentals\" && kubectl get nodes -o jsonpath='{.items[0].metadata.name}' > \"\$HOME/k8s-fundamentals/node-name.txt\"" \
    --desc "Student extracts control-plane node name to output file" \
    --expect-exit 0

# Step 2: Student verifies file contents
student_exec "cat \"\$HOME/k8s-fundamentals/node-name.txt\"" \
    --desc "Student confirms node name in output file" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully verified cluster access and retrieved the control-plane node name!"
