#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/net-test/port_8080_pid.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: Answer file $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "4251" ]; then
    echo "ERROR: Incorrect PID in $ANSWER_FILE. Expected '4251', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: Listening socket process PID identified correctly."
exit 0
