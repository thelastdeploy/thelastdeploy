#!/bin/bash
set -euo pipefail

LIB="$HOME/lib-test/utils.sh"

if [ ! -f "$LIB" ]; then
    echo "FAIL: $LIB does not exist."
    exit 1
fi

source "$LIB"

INFO_OUT=$(log_info "hello")
if [ "$INFO_OUT" != "[INFO] hello" ]; then
    echo "FAIL: log_info expected '[INFO] hello', got '$INFO_OUT'."
    exit 1
fi

EMPTY_FILE=$(mktemp)
NON_EMPTY_FILE=$(mktemp)
echo "content" > "$NON_EMPTY_FILE"

if ! is_file_empty "$EMPTY_FILE"; then
    echo "FAIL: is_file_empty should return 0 for empty file."
    rm -f "$EMPTY_FILE" "$NON_EMPTY_FILE"
    exit 1
fi

if is_file_empty "$NON_EMPTY_FILE"; then
    echo "FAIL: is_file_empty should return 1 for non-empty file."
    rm -f "$EMPTY_FILE" "$NON_EMPTY_FILE"
    exit 1
fi

rm -f "$EMPTY_FILE" "$NON_EMPTY_FILE"

echo "PASS: Reusable shell library functions verified."
exit 0
