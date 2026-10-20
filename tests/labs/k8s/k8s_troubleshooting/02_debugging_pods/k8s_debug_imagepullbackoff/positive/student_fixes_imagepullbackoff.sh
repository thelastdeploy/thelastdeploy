#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Debug ImagePullBackOff
# Module: k8s-troubleshooting
# Section: 02-debugging-pods
# Lab ID: k8s-debug-imagepullbackoff
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-debug-imagepullbackoff"

# Step 1: Student updates pod image to nginx
student_exec "kubectl set image pod/pull-failed-pod pull-failed-pod=nginx" \
    --desc "Student updates pod container image to nginx" \
    --expect-exit 0

# Step 2: Student waits for pod to reach Running phase
student_exec "kubectl wait --for=condition=Ready pod/pull-failed-pod --timeout=60s" \
    --desc "Student waits for pull-failed-pod to become ready" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: ImagePullBackOff resolved successfully! Pod is running."
