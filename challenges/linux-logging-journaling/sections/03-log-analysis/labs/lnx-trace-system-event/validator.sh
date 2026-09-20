#!/bin/bash
set -euo pipefail

TARGET="$HOME/log-test/session_1042_trace.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

EXPECTED=$(grep "session_id=1042" "$HOME/log-test/system_trace.log")
ACTUAL=$(cat "$TARGET")

if [ "$ACTUAL" != "$EXPECTED" ]; then
    echo "FAIL: Expected '$EXPECTED', got '$ACTUAL'."
    exit 1
fi

echo "PASS: Session event tracing verified."
exit 0
