#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/storage-admin/storage_plan.conf" ] && grep -q "ENTERPRISE_STORAGE_LAYOUT_PLANNED" "$HOME/storage-admin/storage_plan.conf"; then
    echo "PASS: Plan Server Storage verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Plan Server Storage."
    exit 1
fi
