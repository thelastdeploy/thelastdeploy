#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/script-test/resilient.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

if ! grep -q "trap " "$SCRIPT_PATH"; then
    echo "FAIL: $SCRIPT_PATH must use 'trap' for exit/cleanup handling."
    exit 1
fi

# Test missing directory
set +e
"$SCRIPT_PATH" "$HOME/script-test/missing_dir" > /dev/null 2>&1
MISSING_CODE=$?
set -e

if [ "$MISSING_CODE" -eq 0 ]; then
    echo "FAIL: Script returned exit code 0 for non-existent directory. Expected non-zero (e.g. 1)."
    exit 1
fi

# Test valid directory
VALID_DIR="$HOME/script-test/target_dir"
set +e
"$SCRIPT_PATH" "$VALID_DIR" > /dev/null 2>&1
VALID_CODE=$?
set -e

if [ "$VALID_CODE" -ne 0 ]; then
    echo "FAIL: Script returned exit code $VALID_CODE for valid directory. Expected 0."
    exit 1
fi

if [ -f "$VALID_DIR/temp.txt" ]; then
    echo "FAIL: $VALID_DIR/temp.txt was not cleaned up by the trap handler."
    exit 1
fi

echo "PASS: Exit codes and signal trap handlers verified successfully."
exit 0
