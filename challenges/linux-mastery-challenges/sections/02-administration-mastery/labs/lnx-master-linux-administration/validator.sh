#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/mastery-admin/admin_mastery.log" ] && grep -q "SYSTEM_ADMINISTRATION_MASTERED" "$HOME/mastery-admin/admin_mastery.log"; then
    echo "PASS: Master Linux Administration verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Master Linux Administration."
    exit 1
fi
