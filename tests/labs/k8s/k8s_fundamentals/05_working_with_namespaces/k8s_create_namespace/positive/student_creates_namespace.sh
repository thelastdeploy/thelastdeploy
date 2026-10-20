#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create a Namespace
# Module: k8s-fundamentals
# Section: 05-working-with-namespaces
# Lab ID: k8s-create-namespace
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-create-namespace"

# Step 1: Student creates the production namespace
student_exec "kubectl create namespace production" \
    --desc "Student creates namespace production" \
    --expect-exit 0

# Step 2: Student verifies namespace existence
student_exec "kubectl get namespace production" \
    --desc "Student confirms production namespace exists" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Namespace 'production' created successfully!"
