#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/cron-test/cleanup_job.sh"
LOG_PATH="$HOME/cron-test/cleanup.log"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

"$SCRIPT_PATH"

if [ -f "$HOME/cron-test/tmp_logs/old.old" ]; then
    echo "FAIL: $HOME/cron-test/tmp_logs/old.old was not deleted by the cleanup script."
    exit 1
fi

if [ ! -f "$HOME/cron-test/tmp_logs/keep.txt" ]; then
    echo "FAIL: $HOME/cron-test/tmp_logs/keep.txt was deleted unexpectedly."
    exit 1
fi

if [ ! -f "$LOG_PATH" ]; then
    echo "FAIL: $LOG_PATH was not generated."
    exit 1
fi

if ! grep -q "CLEANUP_COMPLETE" "$LOG_PATH"; then
    echo "FAIL: $LOG_PATH does not contain 'CLEANUP_COMPLETE'."
    exit 1
fi

echo "PASS: Automated file cleanup script verified."
exit 0
