#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/mastery-incident/incident_mastery.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "PRODUCTION_INCIDENT_INVESTIGATION_MASTERED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PRODUCTION_INCIDENT_INVESTIGATION_MASTERED'."
    exit 1
fi

echo "PASS: Investigate Production Incident verified successfully."
exit 0
