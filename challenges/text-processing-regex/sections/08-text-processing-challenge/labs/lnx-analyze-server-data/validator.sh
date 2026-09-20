#!/bin/bash
set -euo pipefail

TARGET="$HOME/text-challenge/analysis_report.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "TOTAL_ERRORS: 3" "$TARGET"; then
    echo "FAIL: $TARGET does not contain 'TOTAL_ERRORS: 3'."
    exit 1
fi

if ! grep -q "MOST_FREQUENT_ERROR_IP: 10.0.0.5" "$TARGET"; then
    echo "FAIL: $TARGET does not contain 'MOST_FREQUENT_ERROR_IP: 10.0.0.5'."
    exit 1
fi

echo "PASS: Server log capstone analysis report verified."
exit 0
