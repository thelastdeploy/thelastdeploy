#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Terminate a misbehaving process
# Module: linux-processes-services
# Section: 03-signals
# Lab ID: lnx-stop-misbehaving-process
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-stop-misbehaving-process"

# Step 1: Student checks that the process is currently active
student_exec "pgrep -f bad_process" \
    --desc "Student locates PID of bad_process" \
    --expect-exit 0

# Step 2: Student terminates the misbehaving process using pkill
student_exec "pkill -f bad_process" \
    --desc "Student kills bad_process" \
    --expect-exit 0

# Step 3: Student verifies process is no longer running
student_exec "pgrep -f bad_process || true" \
    --desc "Student confirms process has ceased execution" \
    --expect-exit 0

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Misbehaving process successfully stopped."
