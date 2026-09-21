#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/mon-test/bottleneck.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: Answer file $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "iowait" ]; then
    echo "ERROR: Incorrect metric in $ANSWER_FILE. Expected 'iowait', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: Resource pressure metric identified successfully."
exit 0
