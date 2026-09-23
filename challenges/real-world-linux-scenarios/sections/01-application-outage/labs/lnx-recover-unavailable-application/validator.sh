#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/app-outage/application_recovery.log" ] && grep -q "UNAVAILABLE_APPLICATION_RECOVERED_SUCCESSFULLY" "$HOME/app-outage/application_recovery.log"; then
    echo "PASS: Recover Unavailable Application verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Recover Unavailable Application."
    exit 1
fi
