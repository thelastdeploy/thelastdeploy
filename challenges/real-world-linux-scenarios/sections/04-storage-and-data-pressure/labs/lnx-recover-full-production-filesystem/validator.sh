#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/storage-crisis/filesystem_recovery.log"

if [ ! -f "$TARGET" ] || [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is missing or empty."
    exit 1
fi

if grep -q "FULL_FILESYSTEM_SPACE_RECOVERED_SUCCESSFULLY" "$TARGET"; then
    echo "PASS: Recover Full Production Filesystem verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Recover Full Production Filesystem."
    exit 1
fi
