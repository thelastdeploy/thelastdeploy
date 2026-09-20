#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/sec-test/check_sudo.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

CONTENT=$(cat "$SCRIPT_PATH")

if ! echo "$CONTENT" | grep -Eq "sudo -l"; then
    echo "FAIL: $SCRIPT_PATH missing 'sudo -l' invocation."
    exit 1
fi

echo "PASS: Sudo access inspection script verified."
exit 0
