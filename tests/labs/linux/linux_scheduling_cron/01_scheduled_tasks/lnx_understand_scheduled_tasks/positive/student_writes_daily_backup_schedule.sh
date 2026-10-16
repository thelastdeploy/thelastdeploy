#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Understand Scheduled Task Expressions
# Module: linux-scheduling-cron
# Section: 01-scheduled-tasks
# Lab ID: lnx-understand-scheduled-tasks
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-understand-scheduled-tasks"

# Step 1: Student creates daily 02:30 AM backup cron entry
student_exec "echo '30 2 * * * /usr/local/bin/backup.sh' > ~/cron-test/daily_backup.cron" \
    --desc "Student writes daily 02:30 AM cron expression" \
    --expect-exit 0

# Step 2: Student verifies the recorded schedule entry
student_exec "cat ~/cron-test/daily_backup.cron" \
    --desc "Student verifies recorded cron expression" \
    --expect-exit 0 \
    --expect-stdout "30 2 * * *"

# Step 3: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Daily cron expression verified."
