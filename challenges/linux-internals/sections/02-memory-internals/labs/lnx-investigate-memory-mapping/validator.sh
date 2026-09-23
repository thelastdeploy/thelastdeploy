#!/bin/bash
set -euo pipefail

TARGET="$HOME/mem-internals-test/smaps_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SMAPS_MAPPINGS_INVESTIGATED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SMAPS_MAPPINGS_INVESTIGATED'."
    exit 1
fi

echo "PASS: Shared memory and anonymous mapping investigation verified."
exit 0
