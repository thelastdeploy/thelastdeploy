#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/script-test/backup_logs.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

"$SCRIPT_PATH"

if [ ! -f "$HOME/script-test/backup/app.log.bak" ]; then
    echo "FAIL: $HOME/script-test/backup/app.log.bak missing after running script."
    exit 1
fi

if [ ! -f "$HOME/script-test/backup/auth.log.bak" ]; then
    echo "FAIL: $HOME/script-test/backup/auth.log.bak missing after running script."
    exit 1
fi

echo "PASS: Loop file backup automation verified."
exit 0
