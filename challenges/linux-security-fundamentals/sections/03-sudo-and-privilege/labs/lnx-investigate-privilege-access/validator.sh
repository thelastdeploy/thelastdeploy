#!/bin/bash
set -euo pipefail

TARGET="$HOME/sec-test/permissive_user.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "deploy_user"; then
    echo "FAIL: $TARGET does not contain 'deploy_user'."
    exit 1
fi

echo "PASS: Permissive sudoers rule investigation verified."
exit 0
