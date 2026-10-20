#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Investigate Cluster Pods
# Module: k8s-troubleshooting
# Section: 01-observing-cluster-state
# Lab ID: k8s-investigate-resources
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-investigate-resources"

# Step 1: Student queries kube-system pods and writes sorted names to file
student_exec "kubectl get pods -n kube-system -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | sort > ~/k8s-troubleshooting/kube-system-pods.txt" \
    --desc "Student writes sorted kube-system pod names to file" \
    --expect-exit 0

# Step 2: Student inspects file
student_exec "cat ~/k8s-troubleshooting/kube-system-pods.txt" \
    --desc "Student inspects kube-system-pods.txt" \
    --expect-exit 0 \
    --expect-stdout "coredns"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully queried and matched system pods!"
