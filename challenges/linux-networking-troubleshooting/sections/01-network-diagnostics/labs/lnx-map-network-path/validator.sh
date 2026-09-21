#!/usr/bin/env bash
set -euo pipefail

ANSWER_FILE="$HOME/net-test/target_hop.txt"

if [ ! -f "$ANSWER_FILE" ]; then
    echo "ERROR: Answer file $ANSWER_FILE not found."
    exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$CONTENT" != "10.20.30.40" ]; then
    echo "ERROR: Incorrect IP in $ANSWER_FILE. Expected '10.20.30.40', got '$CONTENT'."
    exit 1
fi

echo "SUCCESS: Network path mapped successfully."
exit 0
