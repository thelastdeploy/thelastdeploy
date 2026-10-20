#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix Service Selector
# Module: k8s-troubleshooting
# Section: 03-debugging-services
# Lab ID: k8s-fix-selector-mismatch
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-fix-selector-mismatch"

# Step 1: Student updates service selector to app=web
student_exec "kubectl set selector service web-service app=web" \
    --desc "Student updates web-service selector to app=web" \
    --expect-exit 0

# Step 2: Student verifies endpoints
student_exec "kubectl get endpoints web-service" \
    --desc "Student inspects web-service endpoints" \
    --expect-exit 0 \
    --expect-stdout "80"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Service selector mismatch fixed successfully!"
