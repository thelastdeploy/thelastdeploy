#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create a Secret
# Module: k8s-configuration-storage
# Section: 02-secrets
# Lab ID: k8s-create-secret
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-create-secret"

# Step 1: Student creates generic secret with password key
student_exec "kubectl create secret generic db-secret --from-literal=password=supersecret" \
    --desc "Student creates db-secret generic secret" \
    --expect-exit 0

# Step 2: Student verifies secret exists
student_exec "kubectl get secret db-secret -o yaml" \
    --desc "Student inspects db-secret" \
    --expect-exit 0 \
    --expect-stdout "password:"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Secret 'db-secret' successfully verified!"
