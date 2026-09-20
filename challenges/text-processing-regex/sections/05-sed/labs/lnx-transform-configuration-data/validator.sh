#!/bin/bash
set -euo pipefail

TARGET="$HOME/text-test/app.conf"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PORT=9090" "$TARGET"; then
    echo "FAIL: $TARGET does not contain 'PORT=9090'."
    exit 1
fi

if ! grep -q "ENV=production" "$TARGET"; then
    echo "FAIL: $TARGET does not contain 'ENV=production'."
    exit 1
fi

echo "PASS: Configuration transformations verified."
exit 0
