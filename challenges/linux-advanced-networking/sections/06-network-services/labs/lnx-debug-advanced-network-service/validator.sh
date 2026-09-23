#!/bin/bash
set -euo pipefail

TARGET="$HOME/svc-net-test/sockets.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SOCKET_BINDINGS_INSPECTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SOCKET_BINDINGS_INSPECTED'."
    exit 1
fi

echo "PASS: Network service socket binding debug verified."
exit 0
