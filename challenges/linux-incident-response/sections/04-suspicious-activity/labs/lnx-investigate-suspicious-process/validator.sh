#!/bin/bash
set -euo pipefail

TARGET="$HOME/suspicious-test/process_analysis.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SUSPICIOUS_PROCESS_INVESTIGATED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SUSPICIOUS_PROCESS_INVESTIGATED'."
    exit 1
fi

echo "PASS: Suspicious process activity investigation verified."
exit 0
