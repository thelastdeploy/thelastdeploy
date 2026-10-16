#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create Step Schedule Cron Entries
# Module: linux-scheduling-cron
# Section: 01-scheduled-tasks
# Lab ID: lnx-create-cron-job
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-create-cron-job"

# Step 1: Student creates 15-minute step schedule cron file
student_exec "echo '*/15 * * * * /usr/local/bin/check_health.sh' > ~/cron-test/step_schedule.cron" \
    --desc "Student writes 15-minute interval cron schedule" \
    --expect-exit 0

# Step 2: Student verifies the recorded schedule entry
student_exec "cat ~/cron-test/step_schedule.cron" \
    --desc "Student verifies recorded cron expression" \
    --expect-exit 0 \
    --expect-stdout "*/15 * * * *"

# Step 3: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Step schedule cron entry verified."
