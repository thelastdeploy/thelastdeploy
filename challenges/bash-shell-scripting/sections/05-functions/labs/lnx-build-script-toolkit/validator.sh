#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/script-test/toolkit.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

touch "$HOME/script-test/existing.tmp"

# Test function is_file_present with existing file
if ! bash -c "source '$SCRIPT_PATH' && is_file_present '$HOME/script-test/existing.tmp'"; then
    echo "FAIL: is_file_present returned non-zero for existing file."
    exit 1
fi

# Test function is_file_present with missing file
if bash -c "source '$SCRIPT_PATH' && is_file_present '$HOME/script-test/missing.tmp'"; then
    echo "FAIL: is_file_present returned 0 for missing file."
    exit 1
fi

echo "PASS: Function 'is_file_present' in toolkit.sh validated."
exit 0
