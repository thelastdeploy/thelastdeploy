#!/bin/bash
set -euo pipefail

SCRIPT="$HOME/atomic-test/safe_update.sh"
TARGET="$HOME/atomic-test/target.txt"

if [ ! -f "$SCRIPT" ] || [ ! -x "$SCRIPT" ]; then
    echo "FAIL: $SCRIPT does not exist or is not executable."
    exit 1
fi

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

TEMP_FILES=$(ls 2>/dev/null $HOME/atomic-test/tmp* || true)
if [ -n "$TEMP_FILES" ]; then
    echo "FAIL: Temporary files were left behind in $HOME/atomic-test/."
    exit 1
fi

echo "PASS: Atomic file replacement and lock protection verified."
exit 0
