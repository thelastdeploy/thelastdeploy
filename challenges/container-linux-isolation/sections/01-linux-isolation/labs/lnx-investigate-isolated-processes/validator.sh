#!/bin/bash
set -euo pipefail

TARGET="$HOME/iso-test/proc_isolation.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "ISOLATED_PROCESSES_INVESTIGATED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'ISOLATED_PROCESSES_INVESTIGATED'."
    exit 1
fi

echo "PASS: Isolated process state investigation verified."
exit 0
