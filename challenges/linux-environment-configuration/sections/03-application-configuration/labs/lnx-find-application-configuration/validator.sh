#!/bin/bash
set -euo pipefail

LIST_FILE="$HOME/env-test/config_files.list"

if [ ! -f "$LIST_FILE" ]; then
    echo "FAIL: $LIST_FILE does not exist."
    exit 1
fi

CONTENT=$(cat "$LIST_FILE")

if ! echo "$CONTENT" | grep -q "nginx.conf"; then
    echo "FAIL: $LIST_FILE missing nginx.conf."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "redis.conf"; then
    echo "FAIL: $LIST_FILE missing redis.conf."
    exit 1
fi

echo "PASS: Configuration files discovery list verified."
exit 0
