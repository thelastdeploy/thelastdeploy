#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Manage User Crontab Files
# Module: linux-scheduling-cron
# Section: 02-crontab
# Lab ID: lnx-manage-user-crontab
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-manage-user-crontab"

# Step 1: Student inspects user schedule file
student_exec "cat ~/cron-test/user_schedule.txt" \
    --desc "Student inspects schedule file" \
    --expect-exit 0 \
    --expect-stdout "find /tmp"

# Step 2: Student saves backup copy to current_crontab.bak
student_exec "cp ~/cron-test/user_schedule.txt ~/cron-test/current_crontab.bak" \
    --desc "Student creates crontab backup file" \
    --expect-exit 0

# Step 3: Student verifies backup file contents
student_exec "cat ~/cron-test/current_crontab.bak" \
    --desc "Student verifies backup file contents" \
    --expect-exit 0 \
    --expect-stdout "0 1 * * *"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: User crontab backup file verified."
