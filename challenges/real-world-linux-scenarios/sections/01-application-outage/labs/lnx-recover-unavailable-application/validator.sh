#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/app-outage/application_recovery.log"

if [ ! -f "$TARGET" ] || [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is missing or empty."
    exit 1
fi

if grep -q "UNAVAILABLE_APPLICATION_RECOVERED_SUCCESSFULLY" "$TARGET"; then
    echo "PASS: Recover Unavailable Application verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Recover Unavailable Application."
    exit 1
fi
