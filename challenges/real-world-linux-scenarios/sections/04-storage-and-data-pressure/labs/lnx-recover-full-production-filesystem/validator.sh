#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/storage-crisis/filesystem_recovery.log" ] && grep -q "FULL_FILESYSTEM_SPACE_RECOVERED_SUCCESSFULLY" "$HOME/storage-crisis/filesystem_recovery.log"; then
    echo "PASS: Recover Full Production Filesystem verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Recover Full Production Filesystem."
    exit 1
fi
