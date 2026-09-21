#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="$HOME/net-challenge/config/server.env"
RESOLV_FILE="$HOME/net-challenge/config/resolv.conf"
STATUS_FILE="$HOME/net-challenge/status/app.status"

if [ ! -f "$ENV_FILE" ]; then
    echo "ERROR: Environment config $ENV_FILE not found!"
    exit 1
fi

if grep -q 'LISTEN_IP="127.0.0.1"' "$ENV_FILE"; then
    echo "ERROR: LISTEN_IP is still restricted to 127.0.0.1 in $ENV_FILE."
    exit 1
fi

if ! grep -q 'LISTEN_IP="0.0.0.0"' "$ENV_FILE"; then
    echo "ERROR: LISTEN_IP=\"0.0.0.0\" not found in $ENV_FILE."
    exit 1
fi

if [ ! -f "$RESOLV_FILE" ]; then
    echo "ERROR: Resolv config $RESOLV_FILE not found!"
    exit 1
fi

if ! grep -q "nameserver 8.8.8.8" "$RESOLV_FILE"; then
    echo "ERROR: nameserver 8.8.8.8 not found in $RESOLV_FILE."
    exit 1
fi

if [ ! -f "$STATUS_FILE" ]; then
    echo "ERROR: Status file $STATUS_FILE not found!"
    exit 1
fi

STATUS_CONTENT=$(tr -d '[:space:]' < "$STATUS_FILE")

if [ "$STATUS_CONTENT" != "CONNECTIVITY:RESTORED" ]; then
    echo "ERROR: Status in $STATUS_FILE is '$STATUS_CONTENT', expected 'CONNECTIVITY:RESTORED'."
    exit 1
fi

echo "SUCCESS: Network connectivity restored and app status verified."
exit 0
