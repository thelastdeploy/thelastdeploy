#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/mon-test/avail_ram.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: Answer file $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "7.0Gi" ]; then
    echo "ERROR: Incorrect RAM value in $ANSWER_FILE. Expected '7.0Gi', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: Available memory capacity identified correctly."
exit 0
