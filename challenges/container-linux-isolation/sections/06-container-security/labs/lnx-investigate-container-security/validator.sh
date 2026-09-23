#!/bin/bash
set -euo pipefail

TARGET="$HOME/container-sec-test/sec_caps.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "CONTAINER_CAPABILITIES_INVESTIGATED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'CONTAINER_CAPABILITIES_INVESTIGATED'."
    exit 1
fi

echo "PASS: Container security capabilities and Seccomp investigation verified."
exit 0
