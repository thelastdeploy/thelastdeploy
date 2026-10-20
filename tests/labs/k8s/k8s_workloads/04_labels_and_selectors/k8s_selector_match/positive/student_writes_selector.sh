#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Selector Match
# Module: k8s-workloads
# Section: 04-labels-and-selectors
# Lab ID: k8s-selector-match
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-selector-match"

# Step 1: Student writes selector expression to selector.txt
student_exec "echo 'tier=frontend,app=store' > ~/k8s-workloads/selector.txt" \
    --desc "Student writes selector query to selector.txt" \
    --expect-exit 0

# Step 2: Student verifies file content
student_exec "cat ~/k8s-workloads/selector.txt" \
    --desc "Student inspects selector.txt contents" \
    --expect-exit 0 \
    --expect-stdout "tier=frontend,app=store"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Selector match query verified successfully!"
