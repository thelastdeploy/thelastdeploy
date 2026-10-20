#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Get Cluster Information
# Module: k8s-fundamentals
# Section: 04-kubectl-basics
# Lab ID: k8s-cluster-information
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-cluster-information"

# Step 1: Student extracts ClusterIP of the kubernetes service
student_exec "mkdir -p \"\$HOME/k8s-fundamentals\" && kubectl get svc kubernetes -o jsonpath='{.spec.clusterIP}' > \"\$HOME/k8s-fundamentals/kubernetes-cluster-ip.txt\"" \
    --desc "Student extracts ClusterIP of kubernetes service" \
    --expect-exit 0

# Step 2: Student verifies file content contains target IP
student_exec "cat \"\$HOME/k8s-fundamentals/kubernetes-cluster-ip.txt\"" \
    --desc "Student verifies extracted ClusterIP" \
    --expect-exit 0 \
    --expect-stdout "10.96.0.1"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully verified cluster IP retrieval!"
