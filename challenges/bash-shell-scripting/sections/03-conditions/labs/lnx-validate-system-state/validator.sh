#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/script-test/check_file.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

# Case 1: Non-existent file
MISSING_OUT=$("$SCRIPT_PATH" "$HOME/script-test/non_existent_file.txt" 2>&1)
if [[ "$MISSING_OUT" != *"MISSING"* ]]; then
    echo "FAIL: Testing with missing file failed. Expected 'MISSING', got: '$MISSING_OUT'"
    exit 1
fi

# Case 2: Empty file
EMPTY_OUT=$("$SCRIPT_PATH" "$HOME/script-test/empty_sample.txt" 2>&1)
if [[ "$EMPTY_OUT" != *"EXISTS"* ]]; then
    echo "FAIL: Testing with empty existing file failed. Expected 'EXISTS', got: '$EMPTY_OUT'"
    exit 1
fi

# Case 3: Active non-empty file
ACTIVE_OUT=$("$SCRIPT_PATH" "$HOME/script-test/active_sample.txt" 2>&1)
if [[ "$ACTIVE_OUT" != *"EXISTS"* ]] || [[ "$ACTIVE_OUT" != *"NON_EMPTY"* ]]; then
    echo "FAIL: Testing with active non-empty file failed. Expected both 'EXISTS' and 'NON_EMPTY', got: '$ACTIVE_OUT'"
    exit 1
fi

echo "PASS: System state and file validation logic verified."
exit 0
