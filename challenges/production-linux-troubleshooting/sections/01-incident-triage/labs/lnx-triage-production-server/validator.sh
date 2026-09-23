#!/bin/bash
set -euo pipefail

TARGET="$HOME/triage-test/triage_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PRODUCTION_SERVER_TRIAGED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PRODUCTION_SERVER_TRIAGED'."
    exit 1
fi

echo "PASS: Production server incident triage verified."
exit 0
