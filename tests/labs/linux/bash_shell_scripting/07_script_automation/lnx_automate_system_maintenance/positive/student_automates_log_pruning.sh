#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Automate System Maintenance and Logging
# Module: bash-shell-scripting
# Section: 07-script-automation
# Lab ID: lnx-automate-system-maintenance
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-automate-system-maintenance"

# Step 1: Student inspects the active_logs directory
student_exec "ls -la ~/script-test/active_logs" \
    --desc "Student inspects files in ~/script-test/active_logs" \
    --expect-exit 0 \
    --expect-stdout "stale.old"

# Step 2: Student writes clean_old_logs.sh
student_exec "cat << 'EOF' > ~/script-test/clean_old_logs.sh
#!/bin/bash
set -euo pipefail

LOG_DIR=\"\$HOME/script-test/active_logs\"
MAINT_LOG=\"\$HOME/script-test/maintenance.log\"

rm -f \"\$LOG_DIR\"/*.old
echo \"[\$(date +'%Y-%m-%d %H:%M:%S')] CLEANUP_COMPLETE\" >> \"\$MAINT_LOG\"
EOF" \
    --desc "Student writes clean_old_logs.sh" \
    --expect-exit 0

# Step 3: Student inspects the script contents
student_exec "cat ~/script-test/clean_old_logs.sh" \
    --desc "Student verifies clean_old_logs.sh contents" \
    --expect-exit 0 \
    --expect-stdout "CLEANUP_COMPLETE"

# Step 4: Student adds execution permission
student_exec "chmod +x ~/script-test/clean_old_logs.sh" \
    --desc "Student marks clean_old_logs.sh executable" \
    --expect-exit 0

# Step 5: Student executes clean_old_logs.sh to test cleanup
student_exec "~/script-test/clean_old_logs.sh" \
    --desc "Student runs clean_old_logs.sh" \
    --expect-exit 0

# Step 6: Student confirms stale.old was deleted while current.log remains
student_exec "test ! -f ~/script-test/active_logs/stale.old && echo 'Stale file removed'" \
    --desc "Student confirms obsolete file was deleted" \
    --expect-exit 0 \
    --expect-stdout "Stale file removed"

# Step 7: Student verifies maintenance.log contains CLEANUP_COMPLETE
student_exec "cat ~/script-test/maintenance.log" \
    --desc "Student confirms maintenance.log entry" \
    --expect-exit 0 \
    --expect-stdout "CLEANUP_COMPLETE"

# Step 8: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: System maintenance script validated."
