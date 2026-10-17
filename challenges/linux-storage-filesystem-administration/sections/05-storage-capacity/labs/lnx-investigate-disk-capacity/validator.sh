#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/storage-test/largest_dir.txt"

if [ ! -s "$ANSWER_FILE" ]; then
    echo "FAIL: File $ANSWER_FILE not found or empty."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")
DIR_NAME=$(basename "$CONTENT")

if [ "$DIR_NAME" != "backups" ]; then
    echo "FAIL: Incorrect directory recorded in $ANSWER_FILE. Expected 'backups', got '$CONTENT'."
    exit 1
fi

echo "PASS: Largest directory correctly identified."
exit 0
