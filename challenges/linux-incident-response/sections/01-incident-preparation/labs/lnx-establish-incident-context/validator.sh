#!/bin/bash
set -euo pipefail

TARGET="$HOME/ir-test/context.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "INCIDENT_CONTEXT_ESTABLISHED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'INCIDENT_CONTEXT_ESTABLISHED'."
    exit 1
fi

echo "PASS: Incident context and initial observation verified."
exit 0
