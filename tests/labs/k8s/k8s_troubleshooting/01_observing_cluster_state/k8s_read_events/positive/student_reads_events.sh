#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Read Warning Events
# Module: k8s-troubleshooting
# Section: 01-observing-cluster-state
# Lab ID: k8s-read-events
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-read-events"

# Step 1: Student writes warning reason FailedScheduling to file
student_exec "echo 'FailedScheduling' > ~/k8s-troubleshooting/warning-reason.txt" \
    --desc "Student writes warning reason to file" \
    --expect-exit 0

# Step 2: Student verifies file content
student_exec "cat ~/k8s-troubleshooting/warning-reason.txt" \
    --desc "Student inspects warning-reason.txt" \
    --expect-exit 0 \
    --expect-stdout "FailedScheduling"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully retrieved and matched the warning reason!"
