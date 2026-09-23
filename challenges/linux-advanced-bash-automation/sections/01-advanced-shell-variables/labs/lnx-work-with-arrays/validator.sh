#!/bin/bash
set -euo pipefail

SERVERS_FILE="$HOME/array-test/servers.txt"
CONFIG_FILE="$HOME/array-test/config.txt"

if [ ! -f "$SERVERS_FILE" ]; then
    echo "FAIL: $SERVERS_FILE does not exist."
    exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
    echo "FAIL: $CONFIG_FILE does not exist."
    exit 1
fi

EXPECTED_SERVERS=$'app-01
db-01
web-01'
ACTUAL_SERVERS=$(cat "$SERVERS_FILE" | sort)

if [ "$ACTUAL_SERVERS" != "$EXPECTED_SERVERS" ]; then
    echo "FAIL: $SERVERS_FILE does not contain expected sorted server list."
    exit 1
fi

if ! grep -q "port=8080" "$CONFIG_FILE" || ! grep -q "env=production" "$CONFIG_FILE"; then
    echo "FAIL: $CONFIG_FILE does not contain port=8080 and env=production."
    exit 1
fi

echo "PASS: Array manipulation verified successfully."
exit 0
