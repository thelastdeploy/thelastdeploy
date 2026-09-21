#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/mon-test/oom_process.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: Answer file $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "java_backend" ]; then
    echo "ERROR: Incorrect process name in $ANSWER_FILE. Expected 'java_backend', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: OOM killer process event identified correctly."
exit 0
