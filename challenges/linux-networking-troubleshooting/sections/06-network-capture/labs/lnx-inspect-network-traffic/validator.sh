#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/net-test/client_ip.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: Answer file $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "192.168.1.50" ]; then
    echo "ERROR: Incorrect IP in $ANSWER_FILE. Expected '192.168.1.50', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: Network capture log inspected and source IP verified."
exit 0
