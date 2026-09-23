#!/bin/bash
set -euo pipefail

TARGET="$HOME/triage-test/incident_baseline.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "INCIDENT_BASELINE_ESTABLISHED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'INCIDENT_BASELINE_ESTABLISHED'."
    exit 1
fi

echo "PASS: Incident state baseline establishment verified."
exit 0
