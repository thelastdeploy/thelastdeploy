#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Inspect Pod Logs
# Module: k8s-pods
# Section: 03-inspecting-pods
# Lab ID: k8s-view-pod-logs
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-view-pod-logs"

# Step 1: Student extracts log message flag from container logs
student_exec "mkdir -p \"\$HOME/k8s-pods\" && kubectl logs logging-pod | grep -o 'FLAG_LOG_MESSAGE_[0-9]\+' > \"\$HOME/k8s-pods/flag.txt\"" \
    --desc "Student extracts flag string from container logs" \
    --expect-exit 0

# Step 2: Student verifies file content contains target flag
student_exec "cat \"\$HOME/k8s-pods/flag.txt\"" \
    --desc "Student confirms extracted flag in output file" \
    --expect-exit 0 \
    --expect-stdout "FLAG_LOG_MESSAGE_9921"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Pod log message verified successfully!"
