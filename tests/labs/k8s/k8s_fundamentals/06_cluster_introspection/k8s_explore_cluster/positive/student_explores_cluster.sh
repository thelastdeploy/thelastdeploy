#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Explore Cluster Services
# Module: k8s-fundamentals
# Section: 06-cluster-introspection
# Lab ID: k8s-explore-cluster
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-explore-cluster"

# Step 1: Student extracts the ClusterIP of app-service in namespace app-space
student_exec "mkdir -p \"\$HOME/k8s-fundamentals\" && kubectl get svc app-service -n app-space -o jsonpath='{.spec.clusterIP}' > \"\$HOME/k8s-fundamentals/app-service-ip.txt\"" \
    --desc "Student extracts ClusterIP of app-service in app-space" \
    --expect-exit 0

# Step 2: Student verifies extracted IP is non-empty
student_exec "test -s \"\$HOME/k8s-fundamentals/app-service-ip.txt\"" \
    --desc "Student confirms target IP file is non-empty" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Service ClusterIP successfully validated!"
