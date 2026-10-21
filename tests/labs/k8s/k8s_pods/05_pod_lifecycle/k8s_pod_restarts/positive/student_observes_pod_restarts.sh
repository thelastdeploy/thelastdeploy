#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Observe Pod Restarts
# Module: k8s-pods
# Section: 05-pod-lifecycle
# Lab ID: k8s-pod-restarts
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-pod-restarts"

# Step 1: Student waits for restart count to reach at least 2 and extracts it
student_exec "mkdir -p \"\$HOME/k8s-pods\" && for i in \$(seq 1 45); do if [ \$(kubectl get pod restart-pod -o jsonpath='{.status.containerStatuses[0].restartCount}' 2>/dev/null || echo 0) -ge 2 ]; then break; fi; sleep 2; done && kubectl get pod restart-pod -o jsonpath='{.status.containerStatuses[0].restartCount}' > \"\$HOME/k8s-pods/restarts.txt\"" \
    --desc "Student monitors and records pod restart count after at least 2 restarts" \
    --expect-exit 0

# Step 2: Student confirms restart count value
student_exec "[ \$(cat \"\$HOME/k8s-pods/restarts.txt\") -ge 2 ]" \
    --desc "Student verifies restart count is at least 2" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Pod restarts successfully verified!"
