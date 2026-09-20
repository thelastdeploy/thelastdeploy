#!/bin/bash
set -euo pipefail

TARGET="$HOME/sec-test/insecure_files.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "secret.key"; then
    echo "FAIL: $TARGET missing world-writable file 'secret.key'."
    exit 1
fi

if echo "$CONTENT" | grep -q "safe.txt"; then
    echo "FAIL: $TARGET contains non-world-writable file 'safe.txt'."
    exit 1
fi

echo "PASS: World-writable file search verified."
exit 0
