#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Label a Resource
# Module: k8s-workloads
# Section: 04-labels-and-selectors
# Lab ID: k8s-add-labels
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-add-labels"

# Step 1: Student adds environment=production label to metadata-pod
student_exec "kubectl label pod metadata-pod environment=production" \
    --desc "Student adds environment=production label to metadata-pod" \
    --expect-exit 0

# Step 2: Student verifies label is present
student_exec "kubectl get pod metadata-pod --show-labels" \
    --desc "Student verifies pod labels" \
    --expect-exit 0 \
    --expect-stdout "environment=production"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Label environment=production verified successfully on metadata-pod!"
