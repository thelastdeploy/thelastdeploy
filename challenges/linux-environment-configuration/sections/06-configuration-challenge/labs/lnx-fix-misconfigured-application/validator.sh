#!/bin/bash
set -euo pipefail

CONF_FILE="$HOME/config-challenge/app.conf"
ENV_FILE="$HOME/config-challenge/.env"
REPORT_FILE="$HOME/config-challenge/fix_report.txt"

# 1. Config file check
if [ ! -f "$CONF_FILE" ]; then
    echo "FAIL: $CONF_FILE does not exist."
    exit 1
fi

if ! grep -q "DB_HOST=db.internal" "$CONF_FILE"; then
    echo "FAIL: $CONF_FILE does not contain 'DB_HOST=db.internal'."
    exit 1
fi

if ! grep -q "PORT=8080" "$CONF_FILE"; then
    echo "FAIL: $CONF_FILE does not contain 'PORT=8080'."
    exit 1
fi

# 2. Env file check
if [ ! -f "$ENV_FILE" ]; then
    echo "FAIL: Environment file $ENV_FILE does not exist."
    exit 1
fi

if ! grep -q "APP_KEY=secret_key_123" "$ENV_FILE"; then
    echo "FAIL: $ENV_FILE does not contain 'APP_KEY=secret_key_123'."
    exit 1
fi

# 3. Report file check
if [ ! -f "$REPORT_FILE" ]; then
    echo "FAIL: Report file $REPORT_FILE does not exist."
    exit 1
fi

if ! grep -q "APP_CONFIG_STATUS: VERIFIED" "$REPORT_FILE"; then
    echo "FAIL: $REPORT_FILE does not contain 'APP_CONFIG_STATUS: VERIFIED'."
    exit 1
fi

echo "PASS: Environment & configuration capstone challenge verified."
exit 0
