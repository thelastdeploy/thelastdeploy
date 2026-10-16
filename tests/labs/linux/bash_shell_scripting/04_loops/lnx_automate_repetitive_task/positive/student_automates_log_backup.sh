#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Automate Repetitive Tasks with Loops
# Module: bash-shell-scripting
# Section: 04-loops
# Lab ID: lnx-automate-repetitive-task
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-automate-repetitive-task"

# Step 1: Student inspects the logs folder
student_exec "ls -la ~/script-test/logs" \
    --desc "Student inspects log files in ~/script-test/logs" \
    --expect-exit 0 \
    --expect-stdout "app.log"

# Step 2: Student writes the backup script using a for loop
student_exec "cat << 'EOF' > ~/script-test/backup_logs.sh
#!/bin/bash
set -euo pipefail

for FILE in \"\$HOME/script-test/logs/\"*.log; do
    cp \"\$FILE\" \"\$HOME/script-test/backup/\$(basename \"\$FILE\").bak\"
done
EOF" \
    --desc "Student writes backup_logs.sh with for loop" \
    --expect-exit 0

# Step 3: Student inspects script contents
student_exec "cat ~/script-test/backup_logs.sh" \
    --desc "Student verifies backup script contents" \
    --expect-exit 0 \
    --expect-stdout "basename"

# Step 4: Student adds execution permissions
student_exec "chmod +x ~/script-test/backup_logs.sh" \
    --desc "Student makes backup_logs.sh executable" \
    --expect-exit 0

# Step 5: Student executes the script to test backup creation
student_exec "~/script-test/backup_logs.sh" \
    --desc "Student runs backup_logs.sh" \
    --expect-exit 0

# Step 6: Student confirms backup directory contains .bak files
student_exec "ls -la ~/script-test/backup" \
    --desc "Student verifies generated backup files" \
    --expect-exit 0 \
    --expect-stdout "app.log.bak"

# Step 7: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Loop file backup automation verified."
