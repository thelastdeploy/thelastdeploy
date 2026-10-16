#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Repair Scheduled System Maintenance Setup
# Module: linux-scheduling-cron
# Section: 06-scheduling-challenge
# Lab ID: lnx-repair-scheduled-maintenance
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-repair-scheduled-maintenance"

# Step 1: Student inspects the broken crontab file
student_exec "cat ~/cron-challenge/maint.crontab" \
    --desc "Student inspects existing crontab contents" \
    --expect-exit 0 \
    --expect-stdout "maint_script.sh"

# Step 2: Student inspects script permissions
student_exec "ls -l ~/cron-challenge/maint_script.sh" \
    --desc "Student checks maint_script.sh file properties" \
    --expect-exit 0 \
    --expect-stdout "maint_script.sh"

# Step 3: Student fixes crontab with PATH, valid 02:00 schedule, absolute path, and redirection
student_exec "printf 'PATH=/usr/local/bin:/usr/bin:/bin\n0 2 * * * %s/cron-challenge/maint_script.sh >> %s/cron-challenge/maint.log 2>&1\n' \"\$HOME\" \"\$HOME\" > ~/cron-challenge/maint.crontab" \
    --desc "Student updates maint.crontab with correct environment, schedule, and redirection" \
    --expect-exit 0

# Step 4: Student verifies crontab contents
student_exec "cat ~/cron-challenge/maint.crontab" \
    --desc "Student verifies repaired maint.crontab" \
    --expect-exit 0 \
    --expect-stdout "PATH=/usr/local/bin:/usr/bin:/bin"

# Step 5: Student grants execute permission to maintenance script
student_exec "chmod +x ~/cron-challenge/maint_script.sh" \
    --desc "Student sets execute permission on maintenance script" \
    --expect-exit 0

# Step 6: Student verifies script executable permission
student_exec "test -x ~/cron-challenge/maint_script.sh && echo 'SCRIPT_EXECUTABLE'" \
    --desc "Student verifies script is executable" \
    --expect-exit 0 \
    --expect-stdout "SCRIPT_EXECUTABLE"

# Step 7: Student writes status confirmation file
student_exec "echo 'CRON_RECOVERY_SUCCESS' > ~/cron-challenge/status.txt" \
    --desc "Student generates recovery status verification file" \
    --expect-exit 0

# Step 8: Student verifies status file content
student_exec "cat ~/cron-challenge/status.txt" \
    --desc "Student confirms status file content" \
    --expect-exit 0 \
    --expect-stdout "CRON_RECOVERY_SUCCESS"

# Step 9: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Scheduled maintenance repair capstone challenge verified."
