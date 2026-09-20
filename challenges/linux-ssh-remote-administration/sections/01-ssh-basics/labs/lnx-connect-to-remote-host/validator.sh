#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/ssh-test/connect.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

CONTENT=$(cat "$SCRIPT_PATH")
if ! echo "$CONTENT" | grep -Eq "ssh (admin@10\.0\.0\.50|admin@remote\.example\.com)"; then
    echo "FAIL: $SCRIPT_PATH should contain SSH connection syntax to user admin at remote host (e.g. 'ssh admin@10.0.0.50')."
    exit 1
fi

echo "PASS: SSH connection syntax validated."
exit 0
