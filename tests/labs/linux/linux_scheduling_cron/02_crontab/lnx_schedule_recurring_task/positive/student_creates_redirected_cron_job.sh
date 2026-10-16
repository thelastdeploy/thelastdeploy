#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Schedule Recurring Tasks with Redirection
# Module: linux-scheduling-cron
# Section: 02-crontab
# Lab ID: lnx-schedule-recurring-task
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-schedule-recurring-task"

# Step 1: Student creates hourly crontab entry with output redirection
student_exec "echo '0 * * * * /usr/local/bin/audit.sh >> ~/cron-test/job.log 2>&1' > ~/cron-test/my_cron.txt" \
    --desc "Student writes hourly audit job with stdout/stderr redirection" \
    --expect-exit 0

# Step 2: Student verifies file content
student_exec "cat ~/cron-test/my_cron.txt" \
    --desc "Student inspects recorded cron snippet" \
    --expect-exit 0 \
    --expect-stdout "2>&1"

# Step 3: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Recurring task schedule entry with output redirection verified."
