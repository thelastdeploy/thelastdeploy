#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create a ConfigMap
# Module: k8s-configuration-storage
# Section: 01-configmaps
# Lab ID: k8s-create-configmap
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-create-configmap"

# Step 1: Student creates ConfigMap from literal
student_exec "kubectl create configmap app-config --from-literal=app.environment=production" \
    --desc "Student creates app-config ConfigMap" \
    --expect-exit 0

# Step 2: Student verifies ConfigMap data
student_exec "kubectl get configmap app-config -o yaml" \
    --desc "Student inspects app-config ConfigMap" \
    --expect-exit 0 \
    --expect-stdout "production"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: ConfigMap 'app-config' successfully verified!"
