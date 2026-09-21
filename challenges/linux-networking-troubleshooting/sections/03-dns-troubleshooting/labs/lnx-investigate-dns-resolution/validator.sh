#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/net-test/resolved_ip.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: Answer file $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "10.250.0.15" ]; then
    echo "ERROR: Incorrect IP in $ANSWER_FILE. Expected '10.250.0.15', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: DNS resolution query audited successfully."
exit 0
