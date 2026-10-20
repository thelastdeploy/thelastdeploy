#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Switch Default Namespace
# Module: k8s-fundamentals
# Section: 05-working-with-namespaces
# Lab ID: k8s-switch-namespace
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-switch-namespace"

# Step 1: Student sets default namespace in current context
student_exec "kubectl config set-context --current --namespace=development" \
    --desc "Student sets active namespace to development" \
    --expect-exit 0

# Step 2: Student verifies current context namespace
student_exec "kubectl config view --minify -o jsonpath='{..namespace}'" \
    --desc "Student confirms active namespace is development" \
    --expect-exit 0 \
    --expect-stdout "development"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully switched default context namespace to development!"
