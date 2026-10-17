#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/security-incident/incident_containment.log"

if [ ! -f "$TARGET" ] || [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is missing or empty."
    exit 1
fi

if grep -q "COMPROMISED_SERVICE_CONTAINED_AND_RECOVERED" "$TARGET"; then
    echo "PASS: Recover Compromised Service verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Recover Compromised Service."
    exit 1
fi
