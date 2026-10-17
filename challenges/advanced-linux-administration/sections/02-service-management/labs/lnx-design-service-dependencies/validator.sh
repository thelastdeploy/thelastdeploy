#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/service-stack/service_dependencies.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "SYSTEMD_SERVICE_DEPENDENCIES_CONFIGURED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SYSTEMD_SERVICE_DEPENDENCIES_CONFIGURED'."
    exit 1
fi

echo "PASS: Design Service Dependencies verified successfully."
exit 0
