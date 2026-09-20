#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/cron-test/at_command.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

CONTENT=$(cat "$SCRIPT_PATH")
if ! echo "$CONTENT" | grep -Eq "at (02:00|2:00|now|\+)" ; then
    echo "FAIL: $SCRIPT_PATH should contain 'at' command syntax to schedule a task."
    exit 1
fi

echo "PASS: One-time task scheduling command verified."
exit 0
