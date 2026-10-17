#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/admin-auto/maintenance_workflow.status"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "SYSTEMD_TIMER_MAINTENANCE_WORKFLOW_ACTIVE" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SYSTEMD_TIMER_MAINTENANCE_WORKFLOW_ACTIVE'."
    exit 1
fi

echo "PASS: Build Maintenance Workflow verified successfully."
exit 0
