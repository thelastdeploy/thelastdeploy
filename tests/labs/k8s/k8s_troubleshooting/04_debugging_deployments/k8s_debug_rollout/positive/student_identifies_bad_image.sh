#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Identify Stuck Rollout Cause
# Module: k8s-troubleshooting
# Section: 04-debugging-deployments
# Lab ID: k8s-debug-rollout
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-debug-rollout"

# Step 1: Student inspects deployment image and saves to bad-image.txt
student_exec "kubectl get deployment rollout-app -o jsonpath='{.spec.template.spec.containers[0].image}' > ~/k8s-troubleshooting/bad-image.txt" \
    --desc "Student extracts invalid image tag to bad-image.txt" \
    --expect-exit 0

# Step 2: Student inspects bad-image.txt
student_exec "cat ~/k8s-troubleshooting/bad-image.txt" \
    --desc "Student inspects bad-image.txt" \
    --expect-exit 0 \
    --expect-stdout "nginx:1.161.typo"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully identified the stuck rollout image tag!"
