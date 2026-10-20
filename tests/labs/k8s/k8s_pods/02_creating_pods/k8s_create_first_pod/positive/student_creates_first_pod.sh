#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create Your First Pod
# Module: k8s-pods
# Section: 02-creating-pods
# Lab ID: k8s-create-first-pod
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-create-first-pod"

# Step 1: Student imperatively runs nginx-pod
student_exec "kubectl run nginx-pod --image=nginx" \
    --desc "Student creates nginx-pod with nginx image" \
    --expect-exit 0

# Step 2: Student waits for pod to become ready
student_exec "kubectl wait --for=condition=Ready pod/nginx-pod --timeout=60s" \
    --desc "Student waits for nginx-pod to be in Running phase" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully created and running nginx-pod!"
