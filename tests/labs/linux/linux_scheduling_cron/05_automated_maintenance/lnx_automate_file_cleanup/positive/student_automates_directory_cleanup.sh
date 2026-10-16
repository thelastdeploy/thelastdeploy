#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Automate Directory Cleanup and Logging
# Module: linux-scheduling-cron
# Section: 05-automated-maintenance
# Lab ID: lnx-automate-file-cleanup
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-automate-file-cleanup"

# Step 1: Student creates executable cleanup script
student_exec "printf '#!/bin/bash\nrm -f \$HOME/cron-test/tmp_logs/*.old\necho \"CLEANUP_COMPLETE\" >> \$HOME/cron-test/cleanup.log\n' > ~/cron-test/cleanup_job.sh && chmod +x ~/cron-test/cleanup_job.sh" \
    --desc "Student creates cleanup_job.sh script" \
    --expect-exit 0

# Step 2: Student tests executing the cleanup script
student_exec "~/cron-test/cleanup_job.sh" \
    --desc "Student tests running cleanup script" \
    --expect-exit 0

# Step 3: Student verifies cleanup.log content
student_exec "cat ~/cron-test/cleanup.log" \
    --desc "Student verifies recorded log entry" \
    --expect-exit 0 \
    --expect-stdout "CLEANUP_COMPLETE"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Automated file cleanup script verified."
