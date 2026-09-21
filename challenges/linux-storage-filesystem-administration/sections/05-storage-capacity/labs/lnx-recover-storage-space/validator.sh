#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="$HOME/storage-test/cleanup_target/logs"

if [ ! -f "$TARGET_DIR/app.log" ]; then
    echo "ERROR: Active log file app.log missing!"
    exit 1
fi

if [ -f "$TARGET_DIR/old_app_log.bak" ]; then
    echo "ERROR: Stale backup log old_app_log.bak still exists."
    exit 1
fi

echo "SUCCESS: Stale log backup removed and storage space recovered."
exit 0
