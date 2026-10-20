#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Install Kind and Kubectl
# Module: k8s-fundamentals
# Section: 03-installing-a-local-cluster
# Lab ID: k8s-install-kind
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-install-kind"

# Step 1: Student checks kubectl binary availability
student_exec "command -v kubectl" \
    --desc "Student verifies kubectl binary exists in PATH" \
    --expect-exit 0

# Step 2: Student checks kubectl client version
student_exec "kubectl version --client" \
    --desc "Student verifies kubectl client version" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Kubectl is successfully installed and verified!"
