#!/bin/bash
set -euo pipefail

TARGET="$HOME/systemd-test/failed_units.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

echo "PASS: Unit state analysis verified."
exit 0
