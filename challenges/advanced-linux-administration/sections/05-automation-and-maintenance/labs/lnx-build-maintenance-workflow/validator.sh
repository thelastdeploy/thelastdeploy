#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/admin-auto/maintenance_workflow.status" ] && grep -q "SYSTEMD_TIMER_MAINTENANCE_WORKFLOW_ACTIVE" "$HOME/admin-auto/maintenance_workflow.status"; then
    echo "PASS: Build Maintenance Workflow verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Build Maintenance Workflow."
    exit 1
fi
