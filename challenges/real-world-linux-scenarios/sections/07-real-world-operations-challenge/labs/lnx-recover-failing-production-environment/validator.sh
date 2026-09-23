#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/production-recovery/master_recovery_signoff.log" ] && grep -q "CRITICAL_PRODUCTION_ENVIRONMENT_FULLY_RECOVERED" "$HOME/production-recovery/master_recovery_signoff.log"; then
    echo "PASS: Recover Failing Production Environment Capstone verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Recover Failing Production Environment Capstone."
    exit 1
fi
