#!/bin/bash
set -euo pipefail

TARGET="$HOME/svc-sec-test/disabled_svcs.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "UNNECESSARY_SERVICES_DISABLED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'UNNECESSARY_SERVICES_DISABLED'."
    exit 1
fi

echo "PASS: Unnecessary service disabling verified."
exit 0
