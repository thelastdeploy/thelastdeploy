#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/script-test/hello.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable. Use 'chmod +x'."
    exit 1
fi

FIRST_LINE=$(head -n 1 "$SCRIPT_PATH")
if [[ "$FIRST_LINE" != "#!/bin/bash"* ]] && [[ "$FIRST_LINE" != "#!/usr/bin/env bash"* ]]; then
    echo "FAIL: First line of $SCRIPT_PATH must be a valid shebang (e.g. #!/bin/bash)."
    exit 1
fi

OUTPUT=$("$SCRIPT_PATH" 2>&1)
if [[ "$OUTPUT" != *"Hello, Shell!"* ]]; then
    echo "FAIL: Script output should contain 'Hello, Shell!'. Got: '$OUTPUT'"
    exit 1
fi

echo "PASS: Script created and executed successfully."
exit 0
