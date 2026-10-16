#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure System-Wide Crontab Maintenance
# Module: linux-scheduling-cron
# Section: 05-automated-maintenance
# Lab ID: lnx-schedule-system-maintenance
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-schedule-system-maintenance"

# Step 1: Student creates system crontab snippet with root user context
student_exec "echo '0 3 * * * root /usr/local/bin/sys_maint.sh' > ~/cron-test/sys_crontab" \
    --desc "Student writes system crontab entry" \
    --expect-exit 0

# Step 2: Student verifies sys_crontab contents
student_exec "cat ~/cron-test/sys_crontab" \
    --desc "Student verifies sys_crontab contents" \
    --expect-exit 0 \
    --expect-stdout "root /usr/local/bin/sys_maint.sh"

# Step 3: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: System-wide crontab entry verified."
