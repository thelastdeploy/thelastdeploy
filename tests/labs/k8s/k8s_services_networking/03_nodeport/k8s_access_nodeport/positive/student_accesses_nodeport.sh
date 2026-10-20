#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Access NodePort Service
# Module: k8s-services-networking
# Section: 03-nodeport
# Lab ID: k8s-access-nodeport
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-access-nodeport"

# Step 1: Student retrieves node IP and curls NodePort service saving output
student_exec "NODE_IP=\$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type==\"InternalIP\")].address}') && curl -s \"http://\${NODE_IP}:30080\" > ~/k8s-services-networking/nodeport-response.html" \
    --desc "Student fetches node IP and curls NodePort service at port 30080" \
    --expect-exit 0

# Step 2: Student verifies file content
student_exec "cat ~/k8s-services-networking/nodeport-response.html" \
    --desc "Student inspects nodeport-response.html" \
    --expect-exit 0 \
    --expect-stdout "Welcome to nginx!"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: NodePort service accessed successfully!"
