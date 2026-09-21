#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/log-test/journal_query_cmd.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

CONTENT=$(cat "$SCRIPT_PATH")

if ! echo "$CONTENT" | grep -Eq "journalctl -u (ssh|sshd)(\.service)?"; then
    echo "FAIL: $SCRIPT_PATH missing 'journalctl -u ssh.service' or 'journalctl -u sshd'."
    exit 1
fi

if ! echo "$CONTENT" | grep -Eq -- "--since"; then
    echo "FAIL: $SCRIPT_PATH missing time window filter '--since'."
    exit 1
fi

echo "PASS: Journalctl query command syntax verified."
exit 0
