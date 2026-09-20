#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/ssh-test/remote_cmd.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

CONTENT=$(cat "$SCRIPT_PATH")
if ! echo "$CONTENT" | grep -Eq 'ssh [^ ]+ "(df -h|uptime|uname -a)"'; then
    echo "FAIL: $SCRIPT_PATH should execute a remote command via SSH (e.g., ssh user@host \"df -h\")."
    exit 1
fi

echo "PASS: Non-interactive SSH command execution validated."
exit 0
