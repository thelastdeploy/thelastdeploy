#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/ssh-test/debug_cmd.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

CONTENT=$(cat "$SCRIPT_PATH")
if ! echo "$CONTENT" | grep -Eq "ssh -vvv "; then
    echo "FAIL: $SCRIPT_PATH should contain 'ssh -vvv' for maximum verbosity debugging."
    exit 1
fi

echo "PASS: Verbose SSH debugging invocation verified."
exit 0
