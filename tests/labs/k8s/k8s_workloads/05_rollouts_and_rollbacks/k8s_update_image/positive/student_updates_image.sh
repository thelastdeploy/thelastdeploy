#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Update Container Image
# Module: k8s-workloads
# Section: 05-rollouts-and-rollbacks
# Lab ID: k8s-update-image
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-update-image"

# Step 1: Student updates deployment container image
student_exec "kubectl set image deployment/rollout-deploy nginx=nginx:1.16.1" \
    --desc "Student updates image to nginx:1.16.1" \
    --expect-exit 0

# Step 2: Student waits for rollout to complete
student_exec "kubectl rollout status deployment/rollout-deploy --timeout=60s" \
    --desc "Student waits for rollout to complete" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Deployment image successfully updated to nginx:1.16.1 and is running!"
