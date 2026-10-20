#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Access a Service Internal to Cluster
# Module: k8s-services-networking
# Section: 02-services
# Lab ID: k8s-access-service
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-access-service"

# Step 1: Student accesses internal service from client pod and saves response
student_exec "kubectl exec client-pod -- curl -s http://backend-service > ~/k8s-services-networking/backend-response.html" \
    --desc "Student curls backend-service from client-pod and saves response" \
    --expect-exit 0

# Step 2: Student verifies file content
student_exec "cat ~/k8s-services-networking/backend-response.html" \
    --desc "Student inspects backend-response.html" \
    --expect-exit 0 \
    --expect-stdout "Welcome to nginx!"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully accessed the internal cluster service from the client pod!"
