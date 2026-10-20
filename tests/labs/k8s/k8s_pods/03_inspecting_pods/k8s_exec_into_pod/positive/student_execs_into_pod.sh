#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Exec Into Container
# Module: k8s-pods
# Section: 03-inspecting-pods
# Lab ID: k8s-exec-into-pod
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-exec-into-pod"

# Step 1: Student writes container hostname into /tmp/hostname.txt inside the container
student_exec "kubectl exec exec-pod -- sh -c 'hostname > /tmp/hostname.txt'" \
    --desc "Student writes container hostname to /tmp/hostname.txt" \
    --expect-exit 0

# Step 2: Student verifies file content inside the container
student_exec "kubectl exec exec-pod -- cat /tmp/hostname.txt" \
    --desc "Student verifies container hostname output" \
    --expect-exit 0 \
    --expect-stdout "exec-pod"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully validated container execution and hostname entry!"
