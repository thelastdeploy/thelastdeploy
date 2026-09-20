#!/bin/bash
set -euo pipefail

CONF_FILE="$HOME/ssh-test/config_dir/config"

if [ ! -f "$CONF_FILE" ]; then
    echo "FAIL: $CONF_FILE does not exist."
    exit 1
fi

if ! grep -qi "Host prod-web" "$CONF_FILE"; then
    echo "FAIL: $CONF_FILE missing 'Host prod-web' alias definition."
    exit 1
fi

if ! grep -qi "HostName 10.0.1.100" "$CONF_FILE"; then
    echo "FAIL: $CONF_FILE missing 'HostName 10.0.1.100'."
    exit 1
fi

if ! grep -qi "User devops" "$CONF_FILE"; then
    echo "FAIL: $CONF_FILE missing 'User devops'."
    exit 1
fi

if ! grep -qi "Port 2222" "$CONF_FILE"; then
    echo "FAIL: $CONF_FILE missing 'Port 2222'."
    exit 1
fi

PERMS=$(stat -c "%a" "$CONF_FILE")
if [ "$PERMS" != "600" ]; then
    echo "FAIL: $CONF_FILE permission must be 600, found $PERMS."
    exit 1
fi

echo "PASS: SSH client configuration file validated successfully."
exit 0
