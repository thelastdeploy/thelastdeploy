#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/mon-test/root_cause.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: Answer file $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "disk_io" ]; then
    echo "ERROR: Incorrect root cause in $ANSWER_FILE. Expected 'disk_io', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: Resource exhaustion root cause correlated correctly."
exit 0
