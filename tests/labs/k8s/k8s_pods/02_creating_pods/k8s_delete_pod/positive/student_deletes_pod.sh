#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Delete a Pod
# Module: k8s-pods
# Section: 02-creating-pods
# Lab ID: k8s-delete-pod
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-delete-pod"

# Step 1: Student deletes the dynamic-pod
student_exec "kubectl delete pod dynamic-pod --now" \
    --desc "Student deletes pod dynamic-pod" \
    --expect-exit 0

# Step 2: Student confirms pod is deleted
student_exec "! kubectl get pod dynamic-pod &>/dev/null" \
    --desc "Student verifies dynamic-pod no longer exists" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Pod 'dynamic-pod' successfully deleted!"
