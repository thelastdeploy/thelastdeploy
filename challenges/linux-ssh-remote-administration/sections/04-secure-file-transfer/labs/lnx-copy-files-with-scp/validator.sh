#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/ssh-test/transfer_cmd.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

CONTENT=$(cat "$SCRIPT_PATH")
if ! echo "$CONTENT" | grep -Eq "scp .*app\.tar\.gz admin@10\.0\.0\.50:/var/backups/"; then
    echo "FAIL: $SCRIPT_PATH does not contain correct SCP command to copy app.tar.gz to admin@10.0.0.50:/var/backups/."
    exit 1
fi

echo "PASS: SCP file transfer command verified."
exit 0
