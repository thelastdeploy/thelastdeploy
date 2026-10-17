#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/net-sec/ssh_hardening.conf"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "SSH_AND_SUDO_ACCESS_HARDENED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SSH_AND_SUDO_ACCESS_HARDENED'."
    exit 1
fi

echo "PASS: Manage Remote Administration verified successfully."
exit 0
