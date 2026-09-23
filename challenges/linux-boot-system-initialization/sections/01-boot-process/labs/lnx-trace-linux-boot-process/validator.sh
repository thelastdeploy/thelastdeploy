#!/bin/bash
set -euo pipefail

TARGET="$HOME/boot-test/boot_stages.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "1. FIRMWARE" "$TARGET" || ! grep -q "5. SYSTEMD" "$TARGET"; then
    echo "FAIL: $TARGET missing expected boot stages."
    exit 1
fi

echo "PASS: Linux boot process stages verified."
exit 0
