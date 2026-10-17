#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/mem-internals/page_fault_slab.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "PAGE_FAULTS_AND_SLAB_ALLOCATOR_TRACED" "$TARGET"; then
    echo "FAIL: Requirement not met for Trace Memory Management & Page Faults."
    exit 1
fi

echo "PASS: Trace Memory Management & Page Faults verified successfully."
exit 0
