#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Query by Label Selector
# Module: k8s-workloads
# Section: 04-labels-and-selectors
# Lab ID: k8s-query-by-label
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-query-by-label"

# Step 1: Student queries backend pods and writes sorted names to file
student_exec "kubectl get pods -l tier=backend -o custom-columns=':metadata.name' --no-headers | sort > ~/k8s-workloads/backend-pods.txt" \
    --desc "Student queries pods by label tier=backend and saves to backend-pods.txt" \
    --expect-exit 0

# Step 2: Student verifies file content
student_exec "cat ~/k8s-workloads/backend-pods.txt" \
    --desc "Student inspects backend-pods.txt contents" \
    --expect-exit 0 \
    --expect-stdout "pod1"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully queried and verified backend pods list!"
