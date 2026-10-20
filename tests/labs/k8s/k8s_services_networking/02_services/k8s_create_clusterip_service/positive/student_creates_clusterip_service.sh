#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create a ClusterIP Service
# Module: k8s-services-networking
# Section: 02-services
# Lab ID: k8s-create-clusterip-service
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-create-clusterip-service"

# Step 1: Student creates ClusterIP service exposing backend-app
student_exec "kubectl expose deployment backend-app --name=backend-service --port=80 --target-port=80" \
    --desc "Student creates backend-service ClusterIP service" \
    --expect-exit 0

# Step 2: Student verifies service and endpoints
student_exec "kubectl get svc backend-service" \
    --desc "Student inspects backend-service" \
    --expect-exit 0 \
    --expect-stdout "backend-service"

student_exec "kubectl get endpoints backend-service" \
    --desc "Student verifies endpoints for backend-service" \
    --expect-exit 0 \
    --expect-stdout "80"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: ClusterIP service created and targets backend pods successfully!"
