#!/bin/bash
set -euo pipefail

SCRIPT="$HOME/err-test/safe_run.sh"

if [ ! -f "$SCRIPT" ] || [ ! -x "$SCRIPT" ]; then
    echo "FAIL: $SCRIPT does not exist or is not executable."
    exit 1
fi

if ! grep -q "set -euo pipefail" "$SCRIPT"; then
    echo "FAIL: $SCRIPT does not contain 'set -euo pipefail'."
    exit 1
fi

set +e
"$SCRIPT" >/dev/null 2>&1
EXIT_CODE=$?
set -e

if [ "$EXIT_CODE" -ne 2 ]; then
    echo "FAIL: Expected exit code 2 when invoked without arguments, got $EXIT_CODE."
    exit 1
fi

set +e
"$SCRIPT" "$HOME/err-test/safe_run.sh" >/dev/null 2>&1
OK_CODE=$?
set -e

if [ "$OK_CODE" -ne 0 ]; then
    echo "FAIL: Expected exit code 0 when invoked with valid file argument, got $OK_CODE."
    exit 1
fi

echo "PASS: Failure-safe script verified."
exit 0
