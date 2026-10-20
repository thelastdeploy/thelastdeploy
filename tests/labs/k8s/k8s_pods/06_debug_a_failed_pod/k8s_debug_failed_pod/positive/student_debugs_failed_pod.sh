#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Debug Pod Image Typo
# Module: k8s-pods
# Section: 06-debug-a-failed-pod
# Lab ID: k8s-debug-failed-pod
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-debug-failed-pod"

# Step 1: Student updates pod image to correct repository name
student_exec "kubectl set image pod/failing-image-pod failing-image-pod=nginx" \
    --desc "Student updates failing container image to nginx" \
    --expect-exit 0

# Step 2: Student waits for pod to enter Ready condition
student_exec "kubectl wait --for=condition=Ready pod/failing-image-pod --timeout=60s" \
    --desc "Student waits for pod to enter Running state" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully debugged and running pod with correct image!"
