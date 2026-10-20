#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Check Rollout Status
# Module: k8s-workloads
# Section: 05-rollouts-and-rollbacks
# Lab ID: k8s-check-rollout
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-check-rollout"

# Step 1: Student checks rollout status and redirects output to rollout-status.txt
student_exec "kubectl rollout status deployment/rollout-deploy > ~/k8s-workloads/rollout-status.txt" \
    --desc "Student saves rollout status to rollout-status.txt" \
    --expect-exit 0

# Step 2: Student verifies file content
student_exec "cat ~/k8s-workloads/rollout-status.txt" \
    --desc "Student inspects rollout-status.txt" \
    --expect-exit 0 \
    --expect-stdout "successfully rolled out"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Rollout status message verified successfully!"
