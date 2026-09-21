#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/mon-test/saturated_device.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: Answer file $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "sdb" ]; then
    echo "ERROR: Incorrect device in $ANSWER_FILE. Expected 'sdb', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: Saturated disk device identified correctly."
exit 0
