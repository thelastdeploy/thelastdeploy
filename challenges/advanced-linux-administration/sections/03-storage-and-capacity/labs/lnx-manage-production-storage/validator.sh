#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/storage-admin/lvm_expansion.log" ] && grep -q "LIVE_PRODUCTION_STORAGE_EXPANDED_SUCCESSFULLY" "$HOME/storage-admin/lvm_expansion.log"; then
    echo "PASS: Manage Production Storage verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Manage Production Storage."
    exit 1
fi
