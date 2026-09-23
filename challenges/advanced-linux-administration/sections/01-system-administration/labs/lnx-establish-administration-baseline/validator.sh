#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/sysadmin-audit/admin_baseline.conf" ] && grep -q "OPERATIONAL_ADMINISTRATION_BASELINE_ESTABLISHED" "$HOME/sysadmin-audit/admin_baseline.conf"; then
    echo "PASS: Establish Administration Baseline verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Establish Administration Baseline."
    exit 1
fi
