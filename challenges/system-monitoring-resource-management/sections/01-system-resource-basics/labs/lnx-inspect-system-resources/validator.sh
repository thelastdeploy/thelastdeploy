#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/mon-test/total_ram.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: Answer file $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "16Gi" ]; then
    echo "ERROR: Incorrect total RAM in $ANSWER_FILE. Expected '16Gi', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: Total RAM identified successfully."
exit 0
