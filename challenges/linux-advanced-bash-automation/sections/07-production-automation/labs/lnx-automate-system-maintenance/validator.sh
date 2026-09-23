#!/bin/bash
set -euo pipefail

LOG_DIR="$HOME/maint-test/logs"
SUMMARY="$HOME/maint-test/maint_summary.log"

if [ ! -f "$SUMMARY" ]; then
    echo "FAIL: $SUMMARY does not exist."
    exit 1
fi

if ! grep -q "MAINTENANCE_SUCCESS: 3 logs compressed" "$SUMMARY"; then
    echo "FAIL: $SUMMARY missing expected success entry."
    exit 1
fi

GZ_COUNT=$(ls -1 "$LOG_DIR"/old*.gz 2>/dev/null | wc -l)
if [ "$GZ_COUNT" -ne 3 ]; then
    echo "FAIL: Expected 3 compressed .gz files in $LOG_DIR, found $GZ_COUNT."
    exit 1
fi

echo "PASS: Production system maintenance automation verified."
exit 0
