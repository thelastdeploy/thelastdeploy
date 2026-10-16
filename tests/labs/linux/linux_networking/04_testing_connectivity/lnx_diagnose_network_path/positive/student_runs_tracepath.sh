#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Trace network hops
# Module: linux-networking
# Section: 04-testing-connectivity
# Lab ID: lnx-diagnose-network-path
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-diagnose-network-path"

# Step 1: Student runs tracepath to loopback
student_exec "tracepath 127.0.0.1" \
    --desc "Student traces routing path to loopback" \
    --expect-exit 0 \
    --expect-stdout "reached"

# Step 2: Student saves the tracepath command to trace_cmd.txt
student_exec "echo 'tracepath 127.0.0.1' > ~/network-test/trace_cmd.txt" \
    --desc "Student saves trace command syntax" \
    --expect-exit 0

# Step 3: Student verifies recorded command
student_exec "cat ~/network-test/trace_cmd.txt" \
    --desc "Student verifies recorded command" \
    --expect-exit 0 \
    --expect-stdout "tracepath 127.0.0.1"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Network tracing command verified successfully."
