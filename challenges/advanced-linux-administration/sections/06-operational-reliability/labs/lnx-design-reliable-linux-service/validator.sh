#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/reliability/reliability_design.log" ] && grep -q "OPERATIONAL_RELIABILITY_HEALTHCHECK_ACTIVE" "$HOME/reliability/reliability_design.log"; then
    echo "PASS: Design Reliable Linux Service verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Design Reliable Linux Service."
    exit 1
fi
