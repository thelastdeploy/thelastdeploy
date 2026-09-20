#!/bin/bash
set -euo pipefail

TARGET="$HOME/env-test/mock_profile"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -Eq "(source|\.) .*mock_bashrc"; then
    echo "FAIL: $TARGET must source mock_bashrc (e.g. 'source $HOME/env-test/mock_bashrc')."
    exit 1
fi

echo "PASS: Shell startup cascade configuration verified."
exit 0
