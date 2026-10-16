#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Troubleshoot Cron Execution Environment and PATH
# Module: linux-scheduling-cron
# Section: 03-cron-execution
# Lab ID: lnx-troubleshoot-cron-job
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-troubleshoot-cron-job"

# Step 1: Student inspects the broken crontab file
student_exec "cat ~/cron-test/broken_crontab" \
    --desc "Student inspects broken crontab" \
    --expect-exit 0 \
    --expect-stdout "backup.sh"

# Step 2: Student fixes broken crontab with PATH and absolute script path
student_exec "printf 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\n* * * * * /usr/local/bin/backup.sh\n' > ~/cron-test/broken_crontab" \
    --desc "Student fixes PATH and absolute path in broken crontab" \
    --expect-exit 0

# Step 3: Student verifies repaired crontab file
student_exec "cat ~/cron-test/broken_crontab" \
    --desc "Student verifies repaired crontab" \
    --expect-exit 0 \
    --expect-stdout "/usr/local/bin/backup.sh"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Cron environment troubleshooting verified."
