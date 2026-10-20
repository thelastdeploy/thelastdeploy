#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix Stuck Rollout
# Module: k8s-workloads
# Section: 06-recover-a-broken-deployment
# Lab ID: k8s-fix-broken-deployment
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-fix-broken-deployment"

# Step 1: Student updates broken deployment to a valid image
student_exec "kubectl set image deployment/broken-deploy broken-deploy=nginx:1.16.1" \
    --desc "Student updates image to a valid working tag" \
    --expect-exit 0

# Step 2: Student waits for rollout to complete
student_exec "kubectl rollout status deployment/broken-deploy --timeout=60s" \
    --desc "Student waits for rollout to complete" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Stuck deployment successfully recovered and is running!"
