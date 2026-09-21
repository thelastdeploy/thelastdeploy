#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/mon-test/top_cpu_pid.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: Answer file $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "3912" ]; then
    echo "ERROR: Incorrect PID in $ANSWER_FILE. Expected '3912', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: CPU-intensive process PID identified correctly."
exit 0
