#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/storage-test/largest_dir.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: File $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "backups" ]; then
    echo "ERROR: Incorrect directory recorded in $ANSWER_FILE. Expected 'backups', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: Largest directory correctly identified."
exit 0
