#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/net-test/loopback.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: Answer file $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "127.0.0.1" ]; then
    echo "ERROR: Incorrect IP in $ANSWER_FILE. Expected '127.0.0.1', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: Network state inspected correctly."
exit 0
