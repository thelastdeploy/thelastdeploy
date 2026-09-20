#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/log-test/priority_cmd.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

CONTENT=$(cat "$SCRIPT_PATH")

if ! echo "$CONTENT" | grep -Eq "journalctl .*(-p err|-p 3)"; then
    echo "FAIL: $SCRIPT_PATH missing priority filter '-p err' or '-p 3'."
    exit 1
fi

if ! echo "$CONTENT" | grep -Eq "-o json-pretty"; then
    echo "FAIL: $SCRIPT_PATH missing output format option '-o json-pretty'."
    exit 1
fi

echo "PASS: Journal priority and JSON formatting filter verified."
exit 0
