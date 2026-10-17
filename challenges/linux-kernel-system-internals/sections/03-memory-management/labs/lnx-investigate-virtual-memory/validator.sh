#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/mem-internals/vma_analysis.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "VIRTUAL_MEMORY_ADDRESS_MAPPINGS_ANALYZED" "$TARGET"; then
    echo "FAIL: Requirement not met for Investigate Virtual Memory Mappings."
    exit 1
fi

echo "PASS: Investigate Virtual Memory Mappings verified successfully."
exit 0
