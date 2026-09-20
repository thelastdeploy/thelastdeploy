#!/bin/bash
set -euo pipefail

SSH_DIR="$HOME/ssh-test/broken_ssh/.ssh"
AUTH_KEYS="$SSH_DIR/authorized_keys"

if [ ! -d "$SSH_DIR" ]; then
    echo "FAIL: $SSH_DIR does not exist."
    exit 1
fi

if [ ! -f "$AUTH_KEYS" ]; then
    echo "FAIL: $AUTH_KEYS does not exist."
    exit 1
fi

DIR_PERMS=$(stat -c "%a" "$SSH_DIR")
if [ "$DIR_PERMS" != "700" ]; then
    echo "FAIL: $SSH_DIR permissions must be 700, currently $DIR_PERMS."
    exit 1
fi

FILE_PERMS=$(stat -c "%a" "$AUTH_KEYS")
if [ "$FILE_PERMS" != "600" ]; then
    echo "FAIL: $AUTH_KEYS permissions must be 600, currently $FILE_PERMS."
    exit 1
fi

echo "PASS: SSH directory and authorized_keys file permissions restored."
exit 0
