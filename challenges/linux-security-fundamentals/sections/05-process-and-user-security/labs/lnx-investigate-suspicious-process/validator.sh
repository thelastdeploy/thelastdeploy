#!/bin/bash
set -euo pipefail

TARGET="$HOME/sec-test/suspicious_proc.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "2045"; then
    echo "FAIL: $TARGET missing suspicious PID '2045'."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "nc"; then
    echo "FAIL: $TARGET missing suspicious command 'nc'."
    exit 1
fi

echo "PASS: Suspicious process investigation verified."
exit 0
