#!/bin/bash
set -euo pipefail

TARGET="$HOME/timeline-test/event_correlation.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SECURITY_EVENTS_CORRELATED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SECURITY_EVENTS_CORRELATED'."
    exit 1
fi

echo "PASS: Security logs and event signatures correlation verified."
exit 0
