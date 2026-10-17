#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/production-recovery/master_recovery_signoff.log"

if [ ! -f "$TARGET" ] || [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is missing or empty."
    exit 1
fi

if grep -q "CRITICAL_PRODUCTION_ENVIRONMENT_FULLY_RECOVERED" "$TARGET"; then
    echo "PASS: Recover Failing Production Environment Capstone verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Recover Failing Production Environment Capstone."
    exit 1
fi
