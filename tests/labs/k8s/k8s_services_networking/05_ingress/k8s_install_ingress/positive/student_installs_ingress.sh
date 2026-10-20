#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Install an Ingress Controller
# Module: k8s-services-networking
# Section: 05-ingress
# Lab ID: k8s-install-ingress
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-install-ingress"

# Step 1: Student applies ingress controller manifest
student_exec "kubectl apply -f ~/k8s-services-networking/ingress-controller.yaml" \
    --desc "Student applies ingress-controller.yaml" \
    --expect-exit 0

# Step 2: Student waits for rollout to complete
student_exec "kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx --timeout=60s" \
    --desc "Student waits for ingress controller deployment to become ready" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Ingress controller installed and running successfully!"
