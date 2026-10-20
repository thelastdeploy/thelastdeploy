#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Self-Healing Deployment
# Module: k8s-workloads
# Section: 03-replicasets-and-scaling
# Lab ID: k8s-self-healing-demo
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-self-healing-demo"

# Step 1: Student deletes the currently active pod of app-deploy
student_exec "kubectl delete pod -l app=app-deploy --now" \
    --desc "Student deletes running pod to trigger ReplicaSet self-healing" \
    --expect-exit 0

# Step 2: Student waits for replacement pod to be spawned and records its name
student_exec "INIT_POD=\$(cat \"\$HOME/k8s-workloads/initial-pod.txt\") && until [ -n \"\$(kubectl get pods -l app=app-deploy --field-selector=status.phase=Running -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)\" ] && [ \"\$(kubectl get pods -l app=app-deploy -o jsonpath='{.items[0].metadata.name}')\" != \"\$INIT_POD\" ]; do sleep 1; done && kubectl get pods -l app=app-deploy -o jsonpath='{.items[0].metadata.name}' > \"\$HOME/k8s-workloads/new-pod.txt\"" \
    --desc "Student extracts name of newly created replacement pod" \
    --expect-exit 0

# Step 3: Student verifies new pod file is non-empty
student_exec "test -s \"\$HOME/k8s-workloads/new-pod.txt\"" \
    --desc "Student confirms target new pod file exists and is populated" \
    --expect-exit 0

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Self-healing demo verified!"
