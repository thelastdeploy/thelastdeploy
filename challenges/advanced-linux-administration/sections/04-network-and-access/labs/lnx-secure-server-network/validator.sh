#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/net-sec/firewall_hardening.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "STATEFUL_FIREWALL_RULES_CONFIGURED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'STATEFUL_FIREWALL_RULES_CONFIGURED'."
    exit 1
fi

echo "PASS: Secure Server Network verified successfully."
exit 0
