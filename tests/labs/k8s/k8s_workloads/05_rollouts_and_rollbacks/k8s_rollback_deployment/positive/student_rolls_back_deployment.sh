#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Rollback a Deployment
# Module: k8s-workloads
# Section: 05-rollouts-and-rollbacks
# Lab ID: k8s-rollback-deployment
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-rollback-deployment"

# Step 1: Student rolls back deployment to previous revision
student_exec "kubectl rollout undo deployment/rollout-deploy" \
    --desc "Student rolls back rollout-deploy" \
    --expect-exit 0

# Step 2: Student waits for rollback to complete
student_exec "kubectl rollout status deployment/rollout-deploy --timeout=60s" \
    --desc "Student waits for rollback rollout to complete" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Deployment rolled back to nginx:1.14.2 successfully!"
