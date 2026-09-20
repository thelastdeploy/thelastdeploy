#!/bin/bash
set -euo pipefail

TARGET="$HOME/env-test/mock_bashrc"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -Eq "export LAB_ENV=[\"']?devlab[\"']?"; then
    echo "FAIL: $TARGET missing 'export LAB_ENV=\"devlab\"'."
    exit 1
fi

if ! echo "$CONTENT" | grep -Eq "alias syscheck=[\"']?uptime[\"']?"; then
    echo "FAIL: $TARGET missing 'alias syscheck=\"uptime\"'."
    exit 1
fi

echo "PASS: Shell environment configuration verified."
exit 0
