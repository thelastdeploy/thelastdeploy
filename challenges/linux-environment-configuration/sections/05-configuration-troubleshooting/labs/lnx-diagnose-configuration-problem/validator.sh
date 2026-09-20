#!/bin/bash
set -euo pipefail

TARGET="$HOME/env-test/diagnosis.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "ROOT_CAUSE: INVALID_PORT"; then
    echo "FAIL: $TARGET does not contain 'ROOT_CAUSE: INVALID_PORT'."
    exit 1
fi

echo "PASS: Configuration diagnosis report verified."
exit 0
