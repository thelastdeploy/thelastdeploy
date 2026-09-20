#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/env-test/export_cmd.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

CONTENT=$(cat "$SCRIPT_PATH")

if ! echo "$CONTENT" | grep -Eq "export APP_PORT=[\"']?8080[\"']?"; then
    echo "FAIL: $SCRIPT_PATH missing 'export APP_PORT=8080'."
    exit 1
fi

if ! echo "$CONTENT" | grep -Eq "export APP_ENV=[\"']?staging[\"']?"; then
    echo "FAIL: $SCRIPT_PATH missing 'export APP_ENV=staging'."
    exit 1
fi

echo "PASS: Environment exports script verified."
exit 0
