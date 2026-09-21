#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/net-test/status_code.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: Answer file $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "502" ]; then
    echo "ERROR: Incorrect status code in $ANSWER_FILE. Expected '502', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: Application HTTP connection status code traced correctly."
exit 0
