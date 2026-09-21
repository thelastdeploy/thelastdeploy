#!/usr/bin/env bash
set -euo pipefail

CONF_FILE="$HOME/net-test/service_debug/app.conf"

if [ ! -f "$CONF_FILE" ]; then
    echo "ERROR: Configuration file $CONF_FILE not found."
    exit 1
fi

if grep -q 'BIND_ADDRESS="127.0.0.1"' "$CONF_FILE"; then
    echo "ERROR: BIND_ADDRESS is still set to 127.0.0.1 in $CONF_FILE."
    exit 1
fi

if ! grep -q 'BIND_ADDRESS="0.0.0.0"' "$CONF_FILE"; then
    echo "ERROR: BIND_ADDRESS=\"0.0.0.0\" not found in $CONF_FILE."
    exit 1
fi

echo "SUCCESS: Service binding configuration debugged successfully."
exit 0
