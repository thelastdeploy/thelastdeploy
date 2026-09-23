#!/bin/bash
set -euo pipefail

TARGET="$HOME/svc-sec-test/sandboxing.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SERVICE_SANDBOXING_HARDENED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SERVICE_SANDBOXING_HARDENED'."
    exit 1
fi

echo "PASS: systemd service sandboxing hardening verified."
exit 0
