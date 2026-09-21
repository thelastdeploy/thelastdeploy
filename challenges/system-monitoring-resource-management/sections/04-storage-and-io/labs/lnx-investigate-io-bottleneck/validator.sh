#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/mon-test/io_hog_pid.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: Answer file $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "6891" ]; then
    echo "ERROR: Incorrect PID in $ANSWER_FILE. Expected '6891', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: I/O bottleneck process PID identified correctly."
exit 0
