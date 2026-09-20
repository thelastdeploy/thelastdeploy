#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/script-challenge/system_health.sh"
REPORT_PATH="$HOME/script-challenge/report.txt"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

# Shebang and strict mode check
FIRST_LINE=$(head -n 1 "$SCRIPT_PATH")
if [[ "$FIRST_LINE" != "#!/bin/bash"* ]] && [[ "$FIRST_LINE" != "#!/usr/bin/env bash"* ]]; then
    echo "FAIL: $SCRIPT_PATH must start with a valid shebang."
    exit 1
fi

if ! grep -Eq "set -(euo pipefail|eu)" "$SCRIPT_PATH"; then
    echo "FAIL: $SCRIPT_PATH must enable strict mode ('set -eu' or 'set -euo pipefail')."
    exit 1
fi

# Test missing argument invocation
set +e
"$SCRIPT_PATH" > /dev/null 2>&1
NO_ARG_CODE=$?
set -e

if [ "$NO_ARG_CODE" -eq 0 ]; then
    echo "FAIL: Script executed without arguments returned 0. Expected exit code 1."
    exit 1
fi

# Test valid invocation
rm -f "$REPORT_PATH"
"$SCRIPT_PATH" "$REPORT_PATH"

if [ ! -f "$REPORT_PATH" ]; then
    echo "FAIL: Report file $REPORT_PATH was not created."
    exit 1
fi

REPORT_CONTENT=$(cat "$REPORT_PATH")

if [[ "$REPORT_CONTENT" != *"=== SYSTEM HEALTH REPORT ==="* ]]; then
    echo "FAIL: Report does not contain header '=== SYSTEM HEALTH REPORT ==='."
    exit 1
fi

if [[ "$REPORT_CONTENT" != *"DISK_STATUS: OK"* ]]; then
    echo "FAIL: Report does not contain 'DISK_STATUS: OK'."
    exit 1
fi

if [[ "$REPORT_CONTENT" != *"SYSTEM_STATUS: HEALTHY"* ]]; then
    echo "FAIL: Report does not contain 'SYSTEM_STATUS: HEALTHY'."
    exit 1
fi

echo "PASS: System health monitoring capstone challenge script fully verified."
exit 0
