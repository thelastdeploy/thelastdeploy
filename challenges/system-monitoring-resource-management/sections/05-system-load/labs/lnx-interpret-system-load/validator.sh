#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/mon-test/load_15m.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: Answer file $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "8.75" ]; then
    echo "ERROR: Incorrect 15m load in $ANSWER_FILE. Expected '8.75', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: 15-minute load average extracted successfully."
exit 0
