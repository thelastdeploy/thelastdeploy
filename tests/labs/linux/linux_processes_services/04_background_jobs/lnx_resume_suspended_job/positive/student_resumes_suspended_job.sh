#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Resume a suspended process
# Module: linux-processes-services
# Section: 04-background-jobs
# Lab ID: lnx-resume-suspended-job
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-resume-suspended-job"

# Step 1: Student checks state of suspended_job
student_exec "ps aux | grep suspended_job" \
    --desc "Student inspects state of suspended_job" \
    --expect-exit 0 \
    --expect-stdout "suspended_job"

# Step 2: Student resumes the process by sending SIGCONT
student_exec "pkill -CONT -f suspended_job" \
    --desc "Student sends SIGCONT to resume suspended process" \
    --expect-exit 0

# Step 3: Student verifies state is no longer stopped (T)
student_exec "ps -o pid,state,comm -p \$(pgrep -f suspended_job | head -n 1)" \
    --desc "Student verifies process state is active" \
    --expect-exit 0

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Process successfully resumed and is running in the background"
