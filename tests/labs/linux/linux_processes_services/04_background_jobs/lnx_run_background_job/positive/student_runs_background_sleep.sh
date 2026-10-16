#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Start a job in the background
# Module: linux-processes-services
# Section: 04-background-jobs
# Lab ID: lnx-run-background-job
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-run-background-job"

# Step 1: Student creates jobs-test directory
student_exec "mkdir -p ~/jobs-test" \
    --desc "Student creates jobs-test directory" \
    --expect-exit 0

# Step 2: Student launches sleep 999 in the background
student_exec "nohup sleep 999 >/dev/null 2>&1 &" \
    --desc "Student starts sleep 999 in the background" \
    --expect-exit 0

# Step 3: Student queries the PID of the background sleep process
student_exec "pgrep -f 'sleep 999'" \
    --desc "Student finds PID of background process" \
    --expect-exit 0

# Step 4: Student writes the PID to bg_pid.txt
student_exec "pgrep -f 'sleep 999' | head -n 1 > ~/jobs-test/bg_pid.txt" \
    --desc "Student saves PID to bg_pid.txt" \
    --expect-exit 0

# Step 5: Student verifies file content
student_exec "cat ~/jobs-test/bg_pid.txt" \
    --desc "Student inspects recorded PID" \
    --expect-exit 0

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Background sleep process is running successfully."
