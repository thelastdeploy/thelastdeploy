#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/mon-test/user_cpu.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: Answer file $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "85.2" ]; then
    echo "ERROR: Incorrect CPU value in $ANSWER_FILE. Expected '85.2', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: User space CPU utilization audited successfully."
exit 0
