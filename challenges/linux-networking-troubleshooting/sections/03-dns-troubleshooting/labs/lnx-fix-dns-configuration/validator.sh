#!/usr/bin/env bash
set -euo pipefail

CONF_FILE="$HOME/net-test/resolv_fix/resolv.conf"

if [ ! -f "$CONF_FILE" ]; then
    echo "ERROR: Configuration file $CONF_FILE not found."
    exit 1
fi

if grep -q "nameserver 0.0.0.0" "$CONF_FILE"; then
    echo "ERROR: Invalid nameserver 0.0.0.0 still present in $CONF_FILE."
    exit 1
fi

if ! grep -q "nameserver 8.8.8.8" "$CONF_FILE"; then
    echo "ERROR: Updated nameserver 8.8.8.8 not found in $CONF_FILE."
    exit 1
fi

echo "SUCCESS: DNS configuration repaired successfully."
exit 0
