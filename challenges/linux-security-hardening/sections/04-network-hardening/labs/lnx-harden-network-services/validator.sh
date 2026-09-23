#!/bin/bash
set -euo pipefail

TARGET="$HOME/net-sec-test/sshd_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SSHD_CONFIG_HARDENED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SSHD_CONFIG_HARDENED'."
    exit 1
fi

echo "PASS: Network services and SSH hardening verified."
exit 0
