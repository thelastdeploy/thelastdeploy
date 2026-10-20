#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Scale a Deployment
# Module: k8s-workloads
# Section: 03-replicasets-and-scaling
# Lab ID: k8s-scale-deployment
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-scale-deployment"

# Step 1: Student scales deployment to 5 replicas
student_exec "kubectl scale deployment web-deploy --replicas=5" \
    --desc "Student scales web-deploy to 5 replicas" \
    --expect-exit 0

# Step 2: Student waits for all 5 replicas to become ready
student_exec "kubectl rollout status deployment/web-deploy --timeout=60s" \
    --desc "Student waits for scaled replicas to be ready" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Deployment 'web-deploy' successfully scaled to 5 running replicas!"
