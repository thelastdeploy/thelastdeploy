#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Inspect a Pod IP
# Module: k8s-pods
# Section: 03-inspecting-pods
# Lab ID: k8s-inspect-pod
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-inspect-pod"

# Step 1: Student extracts test-pod IP using kubectl jsonpath
student_exec "mkdir -p \"\$HOME/k8s-pods\" && kubectl get pod test-pod -o jsonpath='{.status.podIP}' > \"\$HOME/k8s-pods/pod-ip.txt\"" \
    --desc "Student extracts pod IP into output file" \
    --expect-exit 0

# Step 2: Student verifies file content exists and is non-empty
student_exec "test -s \"\$HOME/k8s-pods/pod-ip.txt\"" \
    --desc "Student confirms target IP file is non-empty" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Pod IP successfully verified!"
