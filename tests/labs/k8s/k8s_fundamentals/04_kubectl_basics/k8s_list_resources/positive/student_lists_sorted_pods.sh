#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: List Cluster Resources
# Module: k8s-fundamentals
# Section: 04-kubectl-basics
# Lab ID: k8s-list-resources
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-list-resources"

# Step 1: Student lists pod names, sorts them, and writes to target file
student_exec "mkdir -p \"\$HOME/k8s-fundamentals\" && kubectl get pods -o custom-columns=':metadata.name' --no-headers | sort > \"\$HOME/k8s-fundamentals/pods-list.txt\"" \
    --desc "Student extracts and sorts pod names into target file" \
    --expect-exit 0

# Step 2: Student verifies file contents
student_exec "cat \"\$HOME/k8s-fundamentals/pods-list.txt\"" \
    --desc "Student verifies sorted pod names" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully listed and verified sorted pod list!"
