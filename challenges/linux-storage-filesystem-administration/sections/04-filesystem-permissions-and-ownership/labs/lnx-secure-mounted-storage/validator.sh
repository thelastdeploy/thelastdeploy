#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="$HOME/storage-test/mounted_dir"
ANSWER_FILE="$HOME/storage-test/sec_audit.txt"

if [ ! -d "$TARGET_DIR" ]; then
    echo "FAIL: Target directory $TARGET_DIR does not exist."
    exit 1
fi

PERMS=$(stat -c "%a" "$TARGET_DIR")
OWNER=$(stat -c "%U:%G" "$TARGET_DIR")

if [ "$PERMS" != "755" ]; then
    echo "FAIL: Permissions on $TARGET_DIR are $PERMS, expected 755."
    exit 1
fi

if [ ! -s "$ANSWER_FILE" ]; then
    echo "FAIL: Answer file $ANSWER_FILE not found or empty."
    exit 1
fi

REPORTED_OWNER=$(tr -d '[:space:]' < "$ANSWER_FILE")

if [ "$REPORTED_OWNER" != "$OWNER" ]; then
    echo "FAIL: Reported owner in $ANSWER_FILE is '$REPORTED_OWNER', expected '$OWNER'."
    exit 1
fi

echo "PASS: Mounted storage permissions secured and audited correctly."
exit 0
