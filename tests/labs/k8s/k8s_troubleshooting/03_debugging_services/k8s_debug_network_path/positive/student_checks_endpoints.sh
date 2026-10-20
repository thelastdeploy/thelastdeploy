#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Debug Service Endpoints
# Module: k8s-troubleshooting
# Section: 03-debugging-services
# Lab ID: k8s-debug-network-path
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-debug-network-path"

# Step 1: Student queries pod IP and saves to endpoints.txt
student_exec "kubectl get pod web-pod -o jsonpath='{.status.podIP}' > ~/k8s-troubleshooting/endpoints.txt" \
    --desc "Student saves web-pod IP to endpoints.txt" \
    --expect-exit 0

# Step 2: Student inspects file
student_exec "cat ~/k8s-troubleshooting/endpoints.txt" \
    --desc "Student inspects endpoints.txt" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Service endpoint network path verified successfully!"
