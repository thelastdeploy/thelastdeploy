#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Debug Pending Pod
# Module: k8s-troubleshooting
# Section: 02-debugging-pods
# Lab ID: k8s-debug-pending-pod
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-debug-pending-pod"

# Step 1: Student deletes un-schedulable pod
student_exec "kubectl delete pod pending-pod" \
    --desc "Student deletes pending-pod" \
    --expect-exit 0

# Step 2: Student updates CPU request in manifest to 100m
student_exec "sed -i 's/cpu: \"100\"/cpu: \"100m\"/' ~/k8s-troubleshooting/pending-pod.yaml" \
    --desc "Student updates CPU request to 100m" \
    --expect-exit 0

# Step 3: Student applies updated manifest
student_exec "kubectl apply -f ~/k8s-troubleshooting/pending-pod.yaml" \
    --desc "Student re-applies pending-pod manifest" \
    --expect-exit 0

# Step 4: Student waits for pod readiness
student_exec "kubectl wait --for=condition=Ready pod/pending-pod --timeout=60s" \
    --desc "Student waits for pending-pod to become ready" \
    --expect-exit 0

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Pending pod scheduling error resolved successfully!"
