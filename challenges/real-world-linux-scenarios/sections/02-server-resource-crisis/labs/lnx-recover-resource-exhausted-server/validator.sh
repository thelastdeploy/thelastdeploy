#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/resource-crisis/oom_recovery.log" ] && grep -q "RESOURCE_EXHAUSTED_SERVER_RECOVERED" "$HOME/resource-crisis/oom_recovery.log"; then
    echo "PASS: Recover Resource-Exhausted Server verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Recover Resource-Exhausted Server."
    exit 1
fi
