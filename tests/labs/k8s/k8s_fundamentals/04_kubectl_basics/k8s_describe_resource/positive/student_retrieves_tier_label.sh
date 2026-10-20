#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Describe a Resource
# Module: k8s-fundamentals
# Section: 04-kubectl-basics
# Lab ID: k8s-describe-resource
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-describe-resource"

# Step 1: Student extracts tier label of web-server pod
student_exec "mkdir -p \"\$HOME/k8s-fundamentals\" && kubectl get pod web-server -o jsonpath='{.metadata.labels.tier}' > \"\$HOME/k8s-fundamentals/web-tier-label.txt\"" \
    --desc "Student extracts tier label of web-server pod" \
    --expect-exit 0

# Step 2: Student verifies extracted label value
student_exec "cat \"\$HOME/k8s-fundamentals/web-tier-label.txt\"" \
    --desc "Student confirms tier label value is web" \
    --expect-exit 0 \
    --expect-stdout "web"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully retrieved the tier label of web-server pod!"
