#!/usr/bin/env bash
set -euo pipefail

CONF_FILE="$HOME/net-test/routing_problem/routes.conf"

if [ ! -f "$CONF_FILE" ]; then
    echo "ERROR: File $CONF_FILE not found."
    exit 1
fi

if grep -q "192.168.99.99" "$CONF_FILE"; then
    echo "ERROR: Unreachable gateway 192.168.99.99 still present in $CONF_FILE."
    exit 1
fi

if ! grep -q "10.0.0.254" "$CONF_FILE"; then
    echo "ERROR: Correct gateway 10.0.0.254 not found in $CONF_FILE."
    exit 1
fi

echo "SUCCESS: Routing problem diagnosed and resolved."
exit 0
