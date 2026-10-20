#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Recover Production Application
# Module: k8s-troubleshooting
# Section: 06-recover-a-broken-application
# Lab ID: k8s-recover-production-application
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-recover-production-application"

# Step 1: Student creates missing ConfigMap frontend-config
student_exec "kubectl create configmap frontend-config --from-literal=APP_ENV=production" \
    --desc "Student creates missing ConfigMap frontend-config" \
    --expect-exit 0

# Step 2: Student updates deployment image to working nginx image
student_exec "kubectl set image deployment/frontend-deploy frontend=nginx:alpine" \
    --desc "Student updates frontend-deploy image to nginx:alpine" \
    --expect-exit 0

# Step 3: Student waits for rollout to complete
student_exec "kubectl rollout status deployment/frontend-deploy --timeout=60s" \
    --desc "Student monitors rollout status until pods are ready" \
    --expect-exit 0

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Production application successfully recovered! ConfigMap created, image fixed, and pod is running."
