#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/storage-crisis/storage_degradation.txt" ] && grep -q "STORAGE_IO_DEGRADATION_DIAGNOSED_AND_TUNED" "$HOME/storage-crisis/storage_degradation.txt"; then
    echo "PASS: Investigate Storage Performance Degradation verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Investigate Storage Performance Degradation."
    exit 1
fi
