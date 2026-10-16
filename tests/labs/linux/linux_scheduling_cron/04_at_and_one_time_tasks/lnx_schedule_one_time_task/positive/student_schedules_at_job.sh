#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Schedule One-Time Tasks with At
# Module: linux-scheduling-cron
# Section: 04-at-and-one-time-tasks
# Lab ID: lnx-schedule-one-time-task
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-schedule-one-time-task"

# Step 1: Student creates script submitting a task using at
student_exec "printf '#!/bin/bash\necho \"/usr/local/bin/sync.sh\" | at now + 1 hour\n' > ~/cron-test/at_command.sh" \
    --desc "Student writes at job submission script" \
    --expect-exit 0

# Step 2: Student makes the script executable
student_exec "chmod +x ~/cron-test/at_command.sh" \
    --desc "Student sets executable permissions on at_command.sh" \
    --expect-exit 0

# Step 3: Student verifies script contents
student_exec "cat ~/cron-test/at_command.sh" \
    --desc "Student verifies script contents" \
    --expect-exit 0 \
    --expect-stdout "at now"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: One-time task scheduling command verified."
