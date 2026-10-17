#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/storage-crisis/storage_degradation.txt"

if [ ! -f "$TARGET" ] || [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is missing or empty."
    exit 1
fi

if grep -q "STORAGE_IO_DEGRADATION_DIAGNOSED_AND_TUNED" "$TARGET"; then
    echo "PASS: Investigate Storage Performance Degradation verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Investigate Storage Performance Degradation."
    exit 1
fi
