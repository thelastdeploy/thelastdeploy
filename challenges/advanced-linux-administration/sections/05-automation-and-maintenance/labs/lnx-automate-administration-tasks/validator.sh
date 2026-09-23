#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/admin-auto/automation_tasks.sh" ] && grep -q "ADMINISTRATION_TASKS_AUTOMATED" "$HOME/admin-auto/automation_tasks.sh"; then
    echo "PASS: Automate Administration Tasks verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Automate Administration Tasks."
    exit 1
fi
