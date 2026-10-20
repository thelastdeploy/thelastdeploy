#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Recover Stuck Rollout
# Module: k8s-troubleshooting
# Section: 04-debugging-deployments
# Lab ID: k8s-recover-failed-update
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-recover-failed-update"

# Step 1: Student updates deployment container image to valid nginx image
student_exec "kubectl set image deployment/rollout-app rollout-app=nginx:1.16.1" \
    --desc "Student updates rollout-app image to nginx:1.16.1" \
    --expect-exit 0

# Step 2: Student waits for rollout to complete
student_exec "kubectl rollout status deployment/rollout-app --timeout=60s" \
    --desc "Student monitors rollout status until complete" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Stuck deployment rollout successfully resolved and updated!"
