#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/sec-test/audit_script.sh"
REPORT_PATH="$HOME/sec-test/audit_findings.txt"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

"$SCRIPT_PATH"

if [ ! -f "$REPORT_PATH" ]; then
    echo "FAIL: $REPORT_PATH was not created."
    exit 1
fi

CONTENT=$(cat "$REPORT_PATH")

if ! echo "$CONTENT" | grep -q "UID_ZERO_COUNT:"; then
    echo "FAIL: $REPORT_PATH missing 'UID_ZERO_COUNT:' finding."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "UNSECURE_SUDO_USERS:"; then
    echo "FAIL: $REPORT_PATH missing 'UNSECURE_SUDO_USERS:' finding."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "WORLD_WRITABLE_COUNT:"; then
    echo "FAIL: $REPORT_PATH missing 'WORLD_WRITABLE_COUNT:' finding."
    exit 1
fi

echo "PASS: System security baseline audit verified."
exit 0
