#!/bin/bash
set -euo pipefail

TARGET="$HOME/scope-test/incident_scope.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "INCIDENT_SCOPE_DETERMINED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'INCIDENT_SCOPE_DETERMINED'."
    exit 1
fi

echo "PASS: Incident scope and lateral movement assessment verified."
exit 0
