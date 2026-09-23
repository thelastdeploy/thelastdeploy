#!/bin/bash
set -euo pipefail

TARGET="$HOME/proc-internals-test/proc_info.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PROCESS_INTERNALS_INSPECTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PROCESS_INTERNALS_INSPECTED'."
    exit 1
fi

echo "PASS: Process task internals inspection verified."
exit 0
