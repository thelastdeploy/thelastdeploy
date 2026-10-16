#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Inspect system service status
# Module: linux-processes-services
# Section: 05-systemd-and-services
# Lab ID: lnx-inspect-service
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-inspect-service"

# Step 1: Student checks cron service status
student_exec "systemctl is-active cron || service cron status" \
    --desc "Student inspects active state of cron service" \
    --expect-exit 0

# Step 2: Student saves active status to cron_status.txt
student_exec "mkdir -p ~/service-test && echo 'active' > ~/service-test/cron_status.txt" \
    --desc "Student records active status in cron_status.txt" \
    --expect-exit 0

# Step 3: Student verifies recorded status
student_exec "cat ~/service-test/cron_status.txt" \
    --desc "Student verifies recorded status value" \
    --expect-exit 0 \
    --expect-stdout "active"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Cron service status inspected successfully."
