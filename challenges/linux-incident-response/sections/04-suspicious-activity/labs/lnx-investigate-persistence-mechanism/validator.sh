#!/bin/bash
set -euo pipefail

TARGET="$HOME/suspicious-test/persistence_report.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PERSISTENCE_MECHANISM_DISCOVERED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PERSISTENCE_MECHANISM_DISCOVERED'."
    exit 1
fi

echo "PASS: Malicious persistence mechanism investigation verified."
exit 0
