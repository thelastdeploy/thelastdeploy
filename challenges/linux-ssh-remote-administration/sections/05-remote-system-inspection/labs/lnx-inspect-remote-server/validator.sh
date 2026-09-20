#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/ssh-test/audit_remote.sh"
REPORT_PATH="$HOME/ssh-test/audit_report.txt"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

"$SCRIPT_PATH" "prod-server"

if [ ! -f "$REPORT_PATH" ]; then
    echo "FAIL: $REPORT_PATH was not created by $SCRIPT_PATH."
    exit 1
fi

CONTENT=$(cat "$REPORT_PATH")
if [[ "$CONTENT" != *"=== REMOTE AUDIT: prod-server ==="* ]]; then
    echo "FAIL: $REPORT_PATH missing header '=== REMOTE AUDIT: prod-server ==='."
    exit 1
fi

if [[ "$CONTENT" != *"MEMORY_STATUS: OK"* ]]; then
    echo "FAIL: $REPORT_PATH missing 'MEMORY_STATUS: OK'."
    exit 1
fi

if [[ "$CONTENT" != *"DISK_STATUS: OK"* ]]; then
    echo "FAIL: $REPORT_PATH missing 'DISK_STATUS: OK'."
    exit 1
fi

echo "PASS: Remote system inspection audit script verified."
exit 0
