#!/bin/bash
set -euo pipefail

CONF_FILE="$HOME/env-test/service.conf"
BAK_FILE="$HOME/env-test/service.conf.bak"

if [ ! -f "$CONF_FILE" ]; then
    echo "FAIL: $CONF_FILE does not exist."
    exit 1
fi

if [ ! -f "$BAK_FILE" ]; then
    echo "FAIL: Backup file $BAK_FILE does not exist."
    exit 1
fi

if ! grep -q "MAX_CONNECTIONS=100" "$BAK_FILE"; then
    echo "FAIL: Backup file $BAK_FILE does not preserve original 'MAX_CONNECTIONS=100'."
    exit 1
fi

if ! grep -q "MAX_CONNECTIONS=500" "$CONF_FILE"; then
    echo "FAIL: Active configuration $CONF_FILE does not contain updated 'MAX_CONNECTIONS=500'."
    exit 1
fi

echo "PASS: Configuration modification and backup retention verified."
exit 0
